# -------------------
# DocumentDB security group
# -------------------
resource "aws_security_group" "docdb_sg" {
  name   = "sockshop-docdb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = var.security_groups
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sockshop-docdb-sg"
  }
}
# -------------------
# subnet group
# -------------------
resource "aws_docdb_subnet_group" "docdb_subnets" {
  name       = "sockshop-docdb-subnet"
  subnet_ids = var.db_subnet_ids
  tags = {
    Name = "sockshop-docdb-subnet"
  }
}

# -------------------
# DocumentDB Cluster
# -------------------
resource "aws_docdb_cluster" "app_cluster" {
  cluster_identifier    = "sockshop-docs"
  master_username       = var.docdb_user
  master_password       = var.docdb_pass
  db_subnet_group_name  = aws_docdb_subnet_group.docdb_subnets.name
  vpc_security_group_ids = [aws_security_group.docdb_sg.id]
  skip_final_snapshot     = true  # only for dev
  # Enable CloudWatch Logs
  enabled_cloudwatch_logs_exports = ["audit", "profiler"]  # Logs to be exported
}

# -------------------
# Cluster Instances (HA)
# -------------------
resource "aws_docdb_cluster_instance" "app_instances" {
  count               = 2
  identifier          = "sockshop-docs-instance-${count.index + 1}"
  cluster_identifier  = aws_docdb_cluster.app_cluster.id
  instance_class      = "db.t3.medium"
}



