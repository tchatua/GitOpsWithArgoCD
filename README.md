# GitOpsWithArgoCD

Argo CD and GitOps: Helm, Kustomize, ApplicationSets, Blue/Green, CI/CD, Plugins, Hooks and many more!

## GitOps

- GitOps is:

  - A set of practices that laverage Git as the single source of truth for declarative infrastructure and application configurations
  - Enables teams to streamline their application delivery process, automate deployments, and improve collaboration
  - GitOps was coined by Weaveworks

- There are 4 principles in GitOps:

  - Declarative configuration;
  - Version Control
  - Automated synchronization
  - Continuous feedback

- Benefits of GitOps:
  - Increase productivity
  - Improved collaboration
  - Enhanced Security
  - faster Recovery

![alt text](image.png)

## ArgoCD

- ArgoCd is:

  - A declarative GitOps continuous delivery tool for K8s
  - Using Git as the single source of truth
  - Can manage multiple Kubernetes Clusters environment

- Key Features of ArgoCD:

  - Declarative and versioned
  - Multi cluster support
  - Automated Sync and Rollback
  - Pluggable deployment strategies
  - extensibility

- ArgoCD Architecture:
  - ArgoCD CD API Server
  - Repository server
  - Application Controller
  - ArgoCd CD CLI

![alt text](image-1.png)

- Advantaged of ArgoCD:
  - Streamlined Deployments
  - Enhanced collaboration
  - Improve security
  - Faster incident response
  - scalability

## GitOps with ArgoCD
- The benefits to managed K8s based applications using GitOps with ArgoCD:
    - Tradditional deployment methods often lack the necessary automation, consistency, and reliability needed in modern environments
    - GitOps relies on Git as a single of truth for declarative infrastructure and provides a clear, version-controlled history of changes.

- **Why Choose argoCD?**
  - ArgoCD is a popular choice to implement GiytOps workflows because of the following:
    - specifically design for K8s native
    - Provide automated deployments (Automatically synchronizes the state of the applications with the desired state defined in my Git repository, reducing manual intervention and human error.)
    - Supports various configuration mangement tools.
    - Enhance Security and Compliance.
    - Facilitates collaboration and transparency.

## Installing and Configuring git
- Installing and configuring Git with the SSH authentication
  - On ubuntu:
```sh
sudo apt update
sudo apt install git -y
git --version
```

  - onfigure the git user information by running:
```sh
git config --global user.name "Arristide Tchatua"
git config --global user.email "tchattua@gmail.com"
git config --global core.editor "vim" # execute
```

  - Create an SSH key-pair:
```sh
ssh-keygen -t ed25519 -C "chattua@gmail.com"
eval "$(ssh-agent -s)
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
# Copy the contents of the key
```

  - Navigate to Gitlab.com
  - Login using SSO.
  - Click on the profile icon.
  - Choose preferences.
  - Choose SSH keys from the left-hand navigation.
  - Paste the contents of the public key in the box.
  - Click add key.

## Kubernetes cluster setup on Ubuntu
- Install Docker by running the following commands:
```sh
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

```

```sh

```

```sh

```

