# Main Terraform configuration file

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    {
      Name = "main-vpc"
    },
    var.tags
  )
}

# Create a Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone

  tags = merge(
    {
      Name = "public-subnet"
    },
    var.tags
  )
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    {
      Name = "main-igw"
    },
    var.tags
  )
}

# Attach Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    {
      Name = "public-route-table"
    },
    var.tags
  )
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create Private Subnet (conditional)
resource "aws_subnet" "private_subnet" {
  count             = var.enable_private_subnet ? 1 : 0
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(
    {
      Name = "private-subnet"
    },
    var.tags
  )
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  count  = var.enable_private_subnet ? 1 : 0
  domain = "vpc"

  tags = merge(
    {
      Name = "nat-eip"
    },
    var.tags
  )
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat" {
  count         = var.enable_private_subnet ? 1 : 0
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = aws_subnet.public_subnet.id

  tags = merge(
    {
      Name = "nat-gateway"
    },
    var.tags
  )

  depends_on = [aws_internet_gateway.igw]
}

# Create Private Route Table
resource "aws_route_table" "private_rt" {
  count  = var.enable_private_subnet ? 1 : 0
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }

  tags = merge(
    {
      Name = "private-route-table"
    },
    var.tags
  )
}

# Associate Private Route Table with Private Subnet
resource "aws_route_table_association" "private_rt_assoc" {
  count          = var.enable_private_subnet ? 1 : 0
  subnet_id      = aws_subnet.private_subnet[0].id
  route_table_id = aws_route_table.private_rt[0].id
}

# Create a Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  # SSH access with CIDR restrictions
  dynamic "ingress" {
    for_each = contains(var.public_ingress_ports, 22) ? [22] : []
    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidr
      description = "Allow SSH access from specified CIDR blocks"
    }
  }

  # HTTP access (open to internet for web server)
  dynamic "ingress" {
    for_each = contains(var.public_ingress_ports, 80) ? [80] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP access from anywhere"
    }
  }

  # Other ports with restricted access
  dynamic "ingress" {
    for_each = [for port in var.public_ingress_ports : port if port != 22 && port != 80]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_ssh_cidr
      description = "Allow port ${ingress.value} from specified CIDR blocks"
    }
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    {
      Name = "ec2-security-group"
    },
    var.tags
  )
}

# Create IAM role for EC2 instance with CloudWatch permissions
resource "aws_iam_role" "ec2_role" {
  name = "${var.tags["Project"]}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    {
      Name = "ec2-cloudwatch-role"
    },
    var.tags
  )
}

# Attach CloudWatch permissions policy
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Create instance profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.tags["Project"]}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# Launch an EC2 Instance
resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  disable_api_termination     = var.enable_termination_protection
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false
    ignore_changes        = [tags["LastModified"]]
  }

  # Use external script file for user data
  user_data = file("${path.module}/scripts/user_data.sh")

  tags = merge(
    {
      Name = "web-server"
    },
    var.tags
  )
}
