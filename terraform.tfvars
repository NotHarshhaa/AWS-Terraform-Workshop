# Example AWS Terraform Workshop - Configuration Variables
# Copy this file to terraform.tfvars and customize with your values

# AWS Configuration
aws_region  = "us-east-1"
aws_profile = "devops-lab"

# Networking Configuration
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "us-east-1a"

# Private Subnet Configuration (Optional)
enable_private_subnet = false # Set to true to create private subnet with NAT gateway
private_subnet_cidr   = "10.0.2.0/24"
nat_instance_type     = "t3.micro"

# EC2 Configuration
ami_id                        = "ami-0c02fb55956c7d316" # Amazon Linux 2023 AMI (us-east-1)
instance_type                 = "t2.micro"
key_name                      = "your-key-pair-name" # IMPORTANT: Replace with your actual key pair name
enable_termination_protection = false

# Security Configuration
public_ingress_ports = [22, 80]      # SSH and HTTP
allowed_ssh_cidr     = ["0.0.0.0/0"] # WARNING: Open to internet. Restrict to your IP for better security

# Tags
tags = {
  Environment = "dev"
  Project     = "AWS-Terraform-Workshop"
  Owner       = "YourName" # Replace with your name/identifier
  ManagedBy   = "Terraform"
}

# Backend Configuration
# Note: These values are only used when setting up the backend with terraform init -backend-config flags
# backend_s3_bucket      = "your-terraform-state-bucket"
# backend_s3_key         = "terraform/state.tfstate"
# backend_s3_region      = "us-east-1"
# backend_dynamodb_table = "your-terraform-lock-table"
