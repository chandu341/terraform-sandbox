provider "aws" {
  region = "ap-south-2"
}
resource "aws_vpc" "Terraform_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform_vpc"
  }
}

resource "aws_internet_gateway" "Terraform_internet_gateway" {
  vpc_id = aws_vpc.Terraform_vpc.id

  tags = {
    Name = "Terraform_internet_gateway"
  }
}

resource "aws_subnet" "Terraform_subnet" {
  vpc_id     = aws_vpc.Terraform_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Terraform_subnet"
  }
}
resource "aws_route_table" "Terraform_route" {
  vpc_id = aws_vpc.Terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terraform_internet_gateway.id
  }

  tags = {
    Name     = "Terraform_route"
    security = "Terraform"
  }
}

resource "aws_route_table_association" "Terraform_route_table_association" {
  subnet_id      = aws_subnet.Terraform_subnet.id
  route_table_id = aws_route_table.Terraform_route.id
}

resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Terraform_vpc.id

  ingress {
    description = "Allow all inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}

