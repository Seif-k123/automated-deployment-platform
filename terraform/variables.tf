variable "region" {}
variable "profile" {}

variable "project_name" {
  default = "devops-platform"
}

variable "environment" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {}

variable "key_name" {}

variable "allowed_ssh_ip" {
  
}
