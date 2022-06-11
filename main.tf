terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket = "terraform-microk8s-stack-backend"
    key    = "backend-state"
    region = "eu-west-2"
  }
}

provider "aws" {
  region  = "eu-west-2"
}

variable "home_ip" {
  type = string
}

variable "public_key_path" {
  type    = string
}

variable "aws_ami_id" {
  type = string
}

resource "aws_key_pair" "master-key" {
  key_name   = "master-key"
  public_key = file(var.public_key_path)
}

variable "subnet_id" {
  type = string
}

resource "aws_instance" "main_server" {
  ami           = var.aws_ami_id
  instance_type = "t4g.medium"
  subnet_id = var.subnet_id
  key_name = aws_key_pair.master-key.key_name
  user_data = file("scripts/fix-k8s-ssl.sh")

  vpc_security_group_ids = [aws_security_group.admin.id]

  associate_public_ip_address = true

  tags = {
    Name = "MicroK8s-1"
  }
}

resource "aws_security_group" "admin" {
  name        = "admin"
  description = "admin-security-group"

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.home_ip]
  }

  ingress {
    description = "HTTPS ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "K8s API Server"
    from_port   = 16443
    to_port     = 16443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort Range"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecr_repository" "ecr_repository" {
  name                 = "jb_ecr_repository"

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "instance_ip_addr" {
  value = aws_instance.main_server.public_ip
}

output "instance_dns" {
  value = aws_instance.main_server.public_dns
}