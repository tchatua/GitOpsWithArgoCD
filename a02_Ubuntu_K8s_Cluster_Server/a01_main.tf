terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # you can pin a version if you wish: version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

# Get latest official Ubuntu AMI from Canonical (owner = 099720109477)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical (official Ubuntu AMIs)
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Import or upload your SSH public key to AWS (create key pair resource using local public key)
resource "aws_key_pair" "deployer" {
  key_name = "${var.vm_name}-key"
  #   public_key = file(expanduser(var.ssh_public_key_path))
  public_key = file(var.ssh_public_key_path)

}

# Allow SSH (and HTTP optionally) from your IP (change 0.0.0.0/0 if needed)
resource "aws_security_group" "ssh_sg" {
  name        = "${var.vm_name}-sg"
  description = "Allow SSH and HTTP from anywhere (adjust for production)"
  vpc_id      = null # leave null to use default VPC

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vm_name}-sg"
  }
}

# EC2 instance
resource "aws_instance" "ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  # Optional user-data to run on first boot (cloud-init)
  user_data = <<-EOF
              #!/bin/bash
              # ##################################################
              # ##################################################
              apt-get update
              apt-get -y upgrade
              # Example: install nginx
              apt-get -y install nginx
              systemctl enable nginx
              systemctl start nginx
              # ##################################################
              # ##################################################
              # Kubernetes cluster setup on Ubuntu
              # Install Docker by running the following commands:
              # Update the list of available packages
              sudo apt-get update
              # Install required dependencies for using HTTPS repositories
              sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
              # Download and add Docker’s official GPG key (used to verify package integrity)
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
              # Add the official Docker repository for Ubuntu (automatically detects your Ubuntu version)
              sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
              # Update package lists again after adding the Docker repository
              sudo apt-get update
              # Install Docker Engine (docker-ce), Docker CLI, and containerd runtime
              sudo apt-get install -y docker-ce docker-ce-cli containerd.io
              # Add the current user to the 'docker' group so Docker can be run without sudo
              sudo usermod -aG docker ${USER}
              # Refresh the group membership without needing to reboot or log out
              newgrp docker
              # Check the installed Docker version (test command)
              docker version
              # ##################################################
              # ##################################################              
              EOF

  tags = {
    Name = var.vm_name
  }

  #   # Wait for SSH to become available (optional)
  #   provisioner "remote-exec" {
  #     inline = [
  #       "echo 'Instance provisioned!'"
  #     ]

  #     connection {
  #       type        = "ssh"
  #       user        = "ubuntu"          # official Ubuntu AMIs use 'ubuntu' user
  #       private_key = file(substr(var.ssh_public_key_path, 0, length(var.ssh_public_key_path))) # NOTE: prefer SSH agent or env var
  #       host        = self.public_ip
  #     }
  #   }
}
