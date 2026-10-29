terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = [var.ami_owner]

  filter {
    name   = "name"
    values = [var.ami_name_filter]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.metadata, {
    Name = var.vpc_name
  })
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index].cidr
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.metadata, {
    Name = var.public_subnets[count.index].name
    Type = "Public"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.metadata, {
    Name = var.internet_gateway_name
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(var.metadata, {
    Name = var.route_table_name
  })
}

resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_default_security_group" "main" {
  vpc_id = aws_vpc.main.id

  ingress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    self      = true
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.metadata, {
    Name = var.security_group_name
  })
}

resource "tls_private_key" "ec2" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2" {
  key_name   = var.key_name
  public_key = tls_private_key.ec2.public_key_openssh
}

resource "aws_instance" "terraform_vm" {
  ami                         = data.aws_ami.ubuntu_2404.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public[0].id
  vpc_security_group_ids      = [aws_default_security_group.main.id]
  key_name                    = aws_key_pair.ec2.key_name
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
  }

  tags = merge(var.metadata, {
    Name = var.ec2_name

  })
  depends_on = [aws_route_table_association.public]

  lifecycle {
    create_before_destroy = true
  }
}


resource "random_id" "s3_suffix" {
  byte_length = 8
}

resource "aws_s3_bucket" "terraform_file" {
  bucket = "${var.s3_bucket_name_prefix}-${random_id.s3_suffix.hex}"

  tags = merge(var.metadata, {
    Name = var.s3_bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "terraform_file" {
  bucket                  = aws_s3_bucket.terraform_file.id
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "terraform_file" {
  bucket       = aws_s3_bucket.terraform_file.id
  key          = "${var.s3_object_name}-${random_id.s3_suffix.hex}.txt"
  content      = var.s3_object_content
  content_type = "text/plain"

  tags = merge(var.metadata, {
    Name = var.s3_object_name
  })
  depends_on = [aws_route_table.public]
}

output "ec2_private_key" {
  description = "Private SSH key for the EC2 instance. Store securely; Terraform state also contains this key."
  value       = tls_private_key.ec2.private_key_pem
  sensitive   = true
}
