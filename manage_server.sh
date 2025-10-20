#!/bin/bash
TF_DIR="./tf"
INSTANCE_ID=$(terraform -chdir=$TF_DIR output -raw instance_id 2>/dev/null || true)
PRIVATE_KEY=$(terraform -chdir=./tf output -raw private_key_path)
SSH_USER=$(terraform -chdir=./tf output -raw ssh_user)

if [ -z "$INSTANCE_ID" ]; then
    echo "Error: Could not get instance ID from Terraform. Run 'terraform apply' first."
    exit 1
fi

case "$1" in
    start)
        aws ec2 start-instances --instance-ids $INSTANCE_ID
        # Wait until instance is running
        aws ec2 wait instance-running --instance-ids $INSTANCE_ID
        # Fetch current public IP
        IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
            --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
        echo "Instance $INSTANCE_ID started."
        echo "Jenkins URL: http://$IP:8080"
        ;;
    stop)
        aws ec2 stop-instances --instance-ids $INSTANCE_ID
        echo "Instance $INSTANCE_ID stopped."
        ;;
    destroy)
        terraform -chdir=$TF_DIR destroy -auto-approve
        ;;
    *)
        echo "Usage: $0 {start|stop|destroy}"
        exit 1
        ;;
esac
