resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = aws_subnet.db[*].id

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  db_name                = "c3ops_db"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
  multi_az               = true

  tags = {
    Name = "${var.project_name}-${var.environment}-db-instance"
  }
}