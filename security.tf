# 1. ALB Security Group (Public)
resource "aws_security_group" "alb_sg" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Internet to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  }
}

# 2. Bastion Host Security Group (Public)
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project_name}-${var.environment}-bastion-sg"
  description = "SSH access for admins"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from Admin IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # PROD TIP: In a real prod environment, replace "0.0.0.0/0" 
    # with your specific Office/VPN IP address.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-bastion-sg"
  }
}

# 3. Web Layer SG (Private) - Accepts from ALB & Bastion
resource "aws_security_group" "web_sg" {
  name        = "${var.project_name}-${var.environment}-web-sg"
  description = "ALB to Web Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Traffic from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-web-sg"
  }
}

# 4. App Layer SG (Private) - Accepts from Web & Bastion
resource "aws_security_group" "app_sg" {
  name        = "${var.project_name}-${var.environment}-app-sg"
  description = "Web to App Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Traffic from Web Tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-app-sg"
  }
}

# 5. DB Layer SG (Private) - Only accepts from App Layer
resource "aws_security_group" "db_sg" {
  name        = "${var.project_name}-${var.environment}-db-sg"
  description = "App to DB Tier"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from App Tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-db-sg"
  }
}