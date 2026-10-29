variable "aws_region" {
  description = "AWS region in which to create the resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "Names and CIDR blocks for the public subnets."
  type = list(object({
    name = string
    cidr = string
  }))
}

variable "vpc_name" {
  description = "Name tag for the VPC."
  type        = string
}

variable "internet_gateway_name" {
  description = "Name tag for the internet gateway."
  type        = string
}

variable "route_table_name" {
  description = "Name tag for the public route table."
  type        = string
}

variable "security_group_name" {
  description = "Name tag for the VPC default security group."
  type        = string
}

variable "ami_owner" {
  description = "AWS account ID that publishes the Ubuntu AMI."
  type        = string
}

variable "ami_name_filter" {
  description = "AMI name pattern for Ubuntu 24.04."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "ec2_name" {
  description = "Name tag for the EC2 instance."
  type        = string
}

variable "key_name" {
  description = "Name of an existing EC2 key pair in the selected AWS region."
  type        = string
}

variable "root_volume_size" {
  description = "EC2 root volume size in GiB."
  type        = number
}

variable "root_volume_type" {
  description = "EC2 root volume type."
  type        = string
}

variable "s3_bucket_name_prefix" {
  description = "Lowercase prefix for the globally unique S3 bucket name."
  type        = string
}

variable "s3_bucket_name" {
  description = "Name tag for the S3 bucket."
  type        = string
}

variable "s3_object_name" {
  description = "Base name for the S3 text object."
  type        = string
}

variable "s3_object_content" {
  description = "Text to store in the S3 object."
  type        = string
}

variable "metadata" {
  description = "Common metadata tags applied to the created resources."
  type        = map(string)
}