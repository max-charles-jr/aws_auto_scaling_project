terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
      Project     = "web-app"
      Owner       = "DevOps Team"
    }
  }
}

# Use default VPC for dev (replace with your VPC module in production)
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Module invocation
module "web_asg" {
  source = "./modules/web-asg"

  environment         = "dev"
  project_name        = var.project_name
  vpc_id              = data.aws_vpc.default.id
  public_subnet_ids   = data.aws_subnets.public.ids
  private_subnet_ids  = data.aws_subnets.public.ids # Using public for dev
  instance_type       = var.instance_type
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size

  tags = {
    CostCenter = "Engineering"
    Terraform  = "true"
  }
}

# Variables
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "web-app"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 4
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

# Outputs
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.web_asg.alb_dns_name
}

output "alb_url" {
  description = "URL of the Application Load Balancer"
  value       = "http://${module.web_asg.alb_dns_name}"
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = module.web_asg.asg_name
}
