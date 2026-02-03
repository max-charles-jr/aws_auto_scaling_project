aws_region       = "us-east-1"
project_name     = "web-app"
instance_type    = "t3.micro"
desired_capacity = 4
min_size         = 2
max_size         = 4

vpc_id             = "vpc-07a6d1131efa2eb5e"
public_subnet_ids  = ["subnet-05f752e28aab6d5af", "subnet-07374f9a05535055c"]
private_subnet_ids = ["subnet-00ffc70ad065149f0", "subnet-0998eec8c56659811"]