variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "AWS availability zone"
  type        = string
  default     = "us-east-1a"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0c55b159cbfafe1f0"  # Example Amazon Linux 2 AMI
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
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
  default     = [22, 80]  # Allow SSH (22) and HTTP (80) by default
}

variable "tags" {
  description = "A map of tags to be applied to resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "AWS-Terraform-Workshop"
    Owner       = "NotHarshhaa"
  }
}
