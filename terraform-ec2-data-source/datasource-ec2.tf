data "aws_vpc" "terraform-aws-testing" {
  id = "vpc-0d9f0aea5550cc65d"
}

data "aws_subnet" "Terraform_Public_Subnet1-testing" {
  id = "subnet-093bf72f2da3ea050"
}

data "aws_security_group" "allow_all" {
  id = "sg-05eaba46ff1247df4"
}