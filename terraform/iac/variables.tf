variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

# variable "project_name" {
#   description = "Project name for resource naming"
#   type        = string
#   default     = "web-app"
# }

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for ASG"
  type        = list(string)
}

# variable "instance_type" {
#   description = "EC2 instance type"
#   type        = string
#   default     = "t3.micro"
# }

# variable "desired_capacity" {
#   description = "Desired number of instances"
#   type        = number
#   default     = 4
# }

# variable "min_size" {
#   description = "Minimum number of instances"
#   type        = number
#   default     = 2
# }

# variable "max_size" {
#   description = "Maximum number of instances"
#   type        = number
#   default     = 4
# }

variable "health_check_grace_period" {
  description = "Time after instance comes into service before checking health"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}
