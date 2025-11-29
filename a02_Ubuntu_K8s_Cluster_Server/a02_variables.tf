variable "aws_region" {
  description = "AWS region to create resources in"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key to upload to AWS (e.g. ~/.ssh/id_rsa.pub)"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
  #   default     = "/home/ubuntu/.ssh/id_rsa.pub"  # <== change this to YOUR real path
}

variable "vm_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "ubuntu-k8s-server"
}
