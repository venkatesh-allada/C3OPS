# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# WEB TIER (Presentation)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_launch_template" "web" {
  name_prefix   = "${var.project_name}-${var.environment}-web-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-web-instance"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  name                = "${var.project_name}-${var.environment}-web-asg"
  vpc_zone_identifier = aws_subnet.web[*].id
  target_group_arns   = [aws_lb_target_group.web.arn]
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Tier"
    value               = "Web"
    propagate_at_launch = true
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# APP TIER (Business Logic)
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_launch_template" "app" {
  name_prefix   = "${var.project_name}-${var.environment}-app-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.project_name}-${var.environment}-app-instance"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  name                = "${var.project_name}-${var.environment}-app-asg"
  vpc_zone_identifier = aws_subnet.app[*].id
  min_size            = 2
  max_size            = 4
  desired_capacity    = 2

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  tag {
    key                 = "Tier"
    value               = "App"
    propagate_at_launch = true
  }
}