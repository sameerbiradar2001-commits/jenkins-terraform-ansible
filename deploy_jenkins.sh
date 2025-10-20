#!/bin/bash

set -e   # Exit on any error
echo "==== Jenkins Auto Deploy Script ===="

# ---- 1️⃣ Check dependencies ----
for cmd in terraform ansible aws; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd is not installed. Please install it first."
    exit 1
  fi
done
echo "All required tools are installed."

if ! aws sts get-caller-identity &> /dev/null; then
    echo "Error: AWS CLI is not configured. Run 'aws configure' or set environment variables."
    exit 1
fi

# ---- 2️⃣ Initialize & apply Terraform ----
TF_DIR="./tf"
echo "Initializing Terraform..."
terraform -chdir=$TF_DIR init

echo "Applying Terraform to create resources..."
terraform -chdir=$TF_DIR apply -auto-approve

# ---- 3️⃣ Generate Ansible hosts ----
ANSIBLE_DIR="./an/ansible"
HOSTS_FILE="$ANSIBLE_DIR/hosts"
mkdir -p $ANSIBLE_DIR

IP=$(terraform -chdir=$TF_DIR output -raw public_ip)
PRIVATE_KEY=$(terraform -chdir=$TF_DIR output -raw private_key_path)
SSH_USER=$(terraform -chdir=$TF_DIR output -raw ssh_user)

cat > $HOSTS_FILE <<EOF
[jenkins_servers]
$IP ansible_user=$SSH_USER ansible_ssh_private_key_file=$PRIVATE_KEY ansible_python_interpreter=/usr/bin/python3
EOF

echo "Ansible hosts file generated at $HOSTS_FILE"

# ---- 4️⃣ Run Ansible playbook ----
echo "Running Ansible playbook to install Jenkins..."
ansible-playbook -i $HOSTS_FILE ./an/install_jenkins.yml



# ---- 5️⃣ Show Jenkins access info ----
PASSWORD=$(ssh -i $PRIVATE_KEY $SSH_USER@$IP "sudo cat /var/lib/jenkins/secrets/initialAdminPassword")
echo "====================================="
echo "Jenkins is ready!"
echo "URL: http://$IP:8080"
echo "Initial Admin Password: $PASSWORD"
echo "====================================="
