#!/bin/bash

# Check if Terraform outputs exist
IP=$(terraform -chdir=../tf output -raw public_ip)
PRIVATE_KEY=$(terraform -chdir=../tf output -raw private_key_path)
SSH_USER=$(terraform -chdir=../tf output -raw ssh_user)

# Directory for Ansible hosts
ANSIBLE_DIR="ansible"
HOSTS_FILE="$ANSIBLE_DIR/hosts"

# Create ansible directory if it doesn't exist
mkdir -p $ANSIBLE_DIR

# Validate outputs
if [ -z "$IP" ] || [ -z "$PRIVATE_KEY" ] || [ -z "$SSH_USER" ]; then
  echo "Error: Terraform outputs are empty. Run 'terraform apply' first."
  exit 1
fi

# Generate hosts file
cat > $HOSTS_FILE <<EOF
[jenkins_servers]
$IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$PRIVATE_KEY ansible_python_interpreter=/usr/bin/python3
EOF

echo "Ansible hosts file generated successfully at $HOSTS_FILE"
