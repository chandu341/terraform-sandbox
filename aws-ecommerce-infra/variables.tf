
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "cloudwithchandu-shop"
}

variable "environment" {
  type    = string
  default = "learning"
}

variable "domain_name" {
  description = "Registered domain; do not include a hostname"
  type        = string
  default     = "cloudwithchandu.site"
}

variable "app_subdomain" {
  description = "Application hostname prefix"
  type        = string
  default     = "shop"
}

variable "vpc_cidr" {
  type    = string
  default = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "Provide a valid IPv4 CIDR."
  }
}

variable "public_subnet_cidrs" {
  type = list(string)

  default = [
    "10.20.1.0/24",
    "10.20.2.0/24",
    "10.20.3.0/24"
  ]

  validation {
    condition     = length(var.public_subnet_cidrs) == 3
    error_message = "Exactly three public subnet CIDRs are required."
  }
}

variable "private_subnet_cidrs" {
  type = list(string)

  default = [
    "10.20.11.0/24",
    "10.20.12.0/24",
    "10.20.13.0/24"
  ]

  validation {
    condition     = length(var.private_subnet_cidrs) == 3
    error_message = "Exactly three private subnet CIDRs are required."
  }
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "key_name" {
  description = "Existing EC2 key pair name in the selected region"
  type        = string
  default     = "mumbai-key"
}

variable "create_hosted_zone" {
  type    = bool
  default = true
}

variable "nat_strategy" {
  description = "single or per_az; this baseline implements single"
  type        = string
  default     = "single"

  validation {
    condition     = contains(["single", "per_az"], var.nat_strategy)
    error_message = "Choose single or per_az."
  }
}

variable "ssh_enabled" {
  description = "Enable SSH ingress; disabled by default"
  type        = bool
  default     = false
}

variable "ssh_allowed_cidr" {
  description = "Trusted IPv4 CIDR permitted to SSH, if enabled"
  type        = string
  default     = ""
}

variable "allowed_client_cidr" {
  description = "Client IPv4 CIDR permitted to access the ALB"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_count" {
  type    = number
  default = 3

  validation {
    condition     = var.instance_count == 3
    error_message = "This learning topology expects three instances."
  }
}

variable "app_port" {
  type    = number
  default = 8080
}
