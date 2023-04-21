resource "aws_db_instance" "this" {
  identifier             = "${local.prefix}-db"
  allocated_storage      = "25"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql5.7"
  db_name                = "employees"
  username               = "root"
  password               = random_password.this.result
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [module.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = false
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.prefix}-rds-subnet-group"
  subnet_ids = module.dynamic_subnets.private_subnet_ids

  tags = {
    Name = "${local.prefix}-rds-subnet-group"
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "_!%^"
}