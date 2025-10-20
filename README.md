# Jenkins Auto Deployment with Terraform & Ansible

This project automates the deployment of a Jenkins server on AWS using Terraform for infrastructure provisioning and Ansible for configuration management.

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
