aws_region         = "ap-south-2"
project_name       = "c3ops"
environment        = "preprod"
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["ap-south-2a", "ap-south-2b"]
allowed_account_id = "809704584374"

instance_type = "t3.micro"
# PROD TIP: Use AWS Secrets Manager for these in a real production environment
db_username = "admin"
db_password = "SecurePassword123!" 