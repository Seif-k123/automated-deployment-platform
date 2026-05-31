# ---------------- Monitoring Security Group ----------------
resource "aws_security_group" "monitoring_sg" {
  name   = "${var.project_name}-monitoring-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_ip]
  }

  ingress {
    description = "Prometheus"
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Grafana"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Node Exporter"
    from_port   = 9100
    to_port     = 9100
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
    Name = "${var.project_name}-monitoring-sg"
  }
}

# ---------------- Monitoring EC2 ----------------
resource "aws_instance" "monitoring" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.monitoring_sg.id]
  key_name               = var.key_name

  tags = {
    Name        = "${var.project_name}-monitoring"
    Environment = var.environment
  }
}

# ---------------- Inventory (servers + monitoring) ----------------
resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content = <<EOT
[servers]
${aws_instance.server.public_ip}
[servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem
ansible_python_interpreter=/usr/bin/python3

[monitoring]
${aws_instance.monitoring.public_ip}
[monitoring:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/${var.key_name}.pem
ansible_python_interpreter=/usr/bin/python3
EOT
}

# ---------------- Output ----------------
output "monitoring_public_ip" {
  value = aws_instance.monitoring.public_ip
}
