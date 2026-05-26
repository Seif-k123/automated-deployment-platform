#!/bin/bash

set -e

echo "🚀 Starting Terraform Apply..."

terraform init
terraform apply -auto-approve

echo "📡 Extracting EC2 Public IP..."

IP=$(terraform output -raw public_ip)

echo "✅ EC2 IP: $IP"

echo "📝 Generating Ansible inventory..."

cat > ../ansible/inventory.ini <<EOF
[servers]
$IP

[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/my-keypair.pem
ansible_python_interpreter=/usr/bin/python3
EOF

echo "🤖 Running Ansible Playbook..."

cd ../ansible
ansible-playbook -i inventory.ini playbook.yml

echo "🎉 Deployment Finished Successfully!"
