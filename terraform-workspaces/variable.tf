variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "subnet_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "subnet_cidr2" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
}

variable "subnet_name" {
  description = "Name tag for the first public subnet"
  type        = string
}

variable "subnet_name2" {
  description = "Name tag for the second public subnet"
  type        = string
}

variable "internet_gateway_name" {
  description = "Name tag for the internet gateway"
  type        = string
}

variable "route_table_name" {
  description = "Name tag for the route table"
  type        = string
}

variable "security_group_name" {
  description = "Name for the security group"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
}
variable "metadata_enable_public_ip" {
  type        = bool
  description = "Controls if the instance gets a public IP"
  default     = true
}

# variable "s3_bucket_name" {
#   description = "Globally unique name for the S3 bucket"
#   type        = string
# }

# variable "s3_bucket_versioning" {
#   description = "Whether versioning is enabled for the S3 bucket"
#   type        = bool
# }

variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}
