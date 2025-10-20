# Jenkins Auto Deployment with Terraform & Ansible

This project automates the deployment of a Jenkins server on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.


> ⚠️ **Note:** This project is designed to be run in **Windows Subsystem for Linux (WSL)** for best compatibility.


## Features
- Creates an EC2 instance with Jenkins installed.
- Configures Jenkins using Ansible playbooks.
- Scripts to manage the server: start, stop, destroy.
- Automatically fetches Jenkins URL and initial admin password.

## Prerequisites
Make sure the following are installed on your local machine:
- [Terraform](https://www.terraform.io/)
- [Ansible](https://www.ansible.com/)
- [AWS CLI](https://aws.amazon.com/cli/)
- Git

Also, ensure your AWS CLI is configured with credentials:

```bash
aws configure
```
## SSH Key Setup

Jenkins and Terraform require SSH keys to securely connect to your EC2 instances. If you don’t have an SSH key yet, follow these steps:

```bash
# Make sure the .ssh folder exists
mkdir -p ~/.ssh

# Generate a new SSH keypair named id_rsa
ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
```

## Scripts Overview

### `deploy_jenkins.sh`
Deploys Jenkins from scratch. This script will:
- Check for required tools (Terraform, Ansible, AWS CLI)
- Apply Terraform to create AWS resources
- Generate Ansible hosts file
- Run Ansible playbook to install Jenkins
- Display Jenkins URL and initial admin password

---

### `manage_server.sh`
Manage the EC2 instance after deployment:

| Action  | Command                        | Description                              |
|---------|--------------------------------|------------------------------------------|
| Start   | `./manage_server.sh start`      | Start the EC2 instance                   |
| Stop    | `./manage_server.sh stop`       | Stop the EC2 instance (data is preserved) |
| Destroy | `./manage_server.sh destroy`    | Destroy the EC2 instance and all data   |
