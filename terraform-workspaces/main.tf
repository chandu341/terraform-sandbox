provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "Terraform_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name        = var.vpc_name
    Environment = var.environment
  })
}

resource "aws_subnet" "Terraform_publicsubnet" {
  vpc_id     = aws_vpc.Terraform_vpc.id
  cidr_block = var.subnet_cidr

  tags = merge(var.tags, {
    Name        = var.subnet_name
    Environment = var.environment
  })
}
resource "aws_subnet" "Terraform_publicsubnet2" {
  vpc_id     = aws_vpc.Terraform_vpc.id
  cidr_block = var.subnet_cidr2

  tags = merge(var.tags, {
    Name        = var.subnet_name2
    Environment = var.environment
  })
}
resource "aws_internet_gateway" "Terraform_internet_gateway" {
  vpc_id = aws_vpc.Terraform_vpc.id

  tags = merge(var.tags, {
    Name        = var.internet_gateway_name
    Environment = var.environment
  })
}
resource "aws_security_group" "allow_all" {
  name        = var.security_group_name
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.Terraform_vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name        = var.security_group_name
    Environment = var.environment
  })
}

resource "aws_route_table" "Terraform_route" {
  vpc_id = aws_vpc.Terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terraform_internet_gateway.id
  }

  tags = merge(var.tags, {
    Name        = var.route_table_name
    Environment = var.environment
  })
}
resource "aws_route_table_association" "Terraform_route_table_association" {
  subnet_id      = aws_subnet.Terraform_publicsubnet.id
  route_table_id = aws_route_table.Terraform_route.id
}
resource "aws_route_table_association" "Terraform_route_table_association2" {
  subnet_id      = aws_subnet.Terraform_publicsubnet2.id
  route_table_id = aws_route_table.Terraform_route.id
}

resource "aws_instance" "Terraform_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.Terraform_publicsubnet.id
  vpc_security_group_ids      = [aws_security_group.allow_all.id]
  associate_public_ip_address = var.metadata_enable_public_ip
  key_name                    = var.key_name
  user_data_replace_on_change = true

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    sudo systemctl start nginx
    sudo systemctl enable nginx

    ENV_NAME="${var.environment}"
    ENV_COLOR="${var.environment == "prod" ? "#d32f2f" : var.environment == "uat" ? "#f59e0b" : var.environment == "qa" ? "#2563eb" : "#10b981"}"

    cat > /var/www/html/index.html <<HTML
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <title>${var.environment} Environment</title>
      <style>
        body {
          margin: 0;
          font-family: Arial, sans-serif;
          background: linear-gradient(135deg, #0f172a, #1e293b);
          color: #fff;
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .card {
          width: 700px;
          background: rgba(15, 23, 42, 0.9);
          border: 2px solid ${var.environment == "prod" ? "#d32f2f" : var.environment == "uat" ? "#f59e0b" : var.environment == "qa" ? "#2563eb" : "#10b981"};
          border-radius: 18px;
          padding: 30px;
          box-shadow: 0 10px 25px rgba(0,0,0,0.4);
          text-align: center;
        }
        .badge {
          display: inline-block;
          padding: 8px 16px;
          border-radius: 999px;
          background: ${var.environment == "prod" ? "#d32f2f" : var.environment == "uat" ? "#f59e0b" : var.environment == "qa" ? "#2563eb" : "#10b981"};
          color: white;
          font-weight: bold;
          letter-spacing: 1px;
          margin-bottom: 20px;
        }
        h1 {
          margin: 10px 0;
          font-size: 42px;
        }
        .info {
          margin-top: 20px;
          font-size: 18px;
          line-height: 1.8;
        }
        .label {
          color: #cbd5e1;
          font-weight: bold;
        }
      </style>
    </head>
    <body>
      <div class="card">
        <div class="badge">${upper(var.environment)}</div>
        <h1>${var.environment} Environment</h1>
        <div class="info">
          <div><span class="label">Instance:</span> ${var.instance_name}</div>
          <div><span class="label">VPC:</span> ${var.vpc_name}</div>
          <div><span class="label">Region:</span> ${var.aws_region}</div>
          <div><span class="label">Status:</span> Running</div>
        </div>
      </div>
    </body>
    </html>
    HTML
  EOF

  tags = merge(var.tags, {
    Name        = var.instance_name
    Environment = var.environment
  })
}
