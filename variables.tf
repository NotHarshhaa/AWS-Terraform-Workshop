variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "The VPC CIDR block must be a valid IPv4 CIDR notation."
  }
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"

  validation {
    condition     = can(cidrhost(var.public_subnet_cidr, 0))
    error_message = "The public subnet CIDR block must be a valid IPv4 CIDR notation."
  }
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1c"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c02fb55956c7d316" # Amazon Linux 2023 AMI (us-east-1)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.small"

  validation {
    condition     = contains(["t2.nano", "t2.micro", "t2.small", "t2.medium", "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large"], var.instance_type)
    error_message = "The instance type must be a valid t2 or t3 instance type."
  }
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the EC2 instance"
  type        = string
}

variable "aws_profile" {
  description = "The AWS CLI profile name to use for authentication"
  type        = string
  default     = "default"
}

variable "enable_termination_protection" {
  description = "Enable termination protection for EC2 instance"
  type        = bool
  default     = false
}

variable "public_ingress_ports" {
  description = "List of public ingress ports for the security group"
  type        = list(number)
  default     = [22, 80] # Allow SSH (22) and HTTP (80) by default

  validation {
    condition     = alltrue([for port in var.public_ingress_ports : port >= 1 && port <= 65535])
    error_message = "All ingress ports must be between 1 and 65535."
  }
}

variable "enable_private_subnet" {
  description = "Enable creation of private subnet with NAT gateway"
  type        = bool
  default     = false
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"

  validation {
    condition     = can(cidrhost(var.private_subnet_cidr, 0))
    error_message = "The private subnet CIDR block must be a valid IPv4 CIDR notation."
  }
}

variable "nat_instance_type" {
  description = "EC2 instance type for NAT gateway (if using NAT instance)"
  type        = string
  default     = "t3.small"

  validation {
    condition     = contains(["t2.nano", "t2.micro", "t2.small", "t2.medium", "t3.nano", "t3.micro", "t3.small", "t3.medium", "t3.large"], var.nat_instance_type)
    error_message = "The NAT instance type must be a valid t2 or t3 instance type."
  }
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks allowed to SSH into the EC2 instance"
  type        = list(string)
  default     = ["0.0.0.0/0"]

  validation {
    condition     = alltrue([for cidr in var.allowed_ssh_cidr : can(cidrhost(cidr, 0))])
    error_message = "All SSH CIDR blocks must be valid IPv4 CIDR notation."
  }
}

variable "tags" {
  description = "A map of tags to be applied to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "AWS-Terraform-Workshop"
    Owner       = "KhanhPhung"
  }
}
