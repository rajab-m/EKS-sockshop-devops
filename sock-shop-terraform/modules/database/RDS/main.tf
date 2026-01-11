# -------------------
# RDS Security Group
# -------------------
resource "aws_security_group" "rds_sg" {
  name   = "sockshop-rds-sg"
  vpc_id = var.vpc_id

  description = "Allow MySQL access from private network"

  ingress {
    from_port   = 3306
    to_port     = 3306
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
    Name = "sockshop-rds-sg"
  }
}

# -------------------
# RDS Subnet Group
# -------------------
resource "aws_db_subnet_group" "db" {
  name       = "sockshop-db-subnet"
  subnet_ids = var.db_subnet_ids
}

# -------------------
# RDS MySQL Catalogue DB
# -------------------
resource "aws_db_instance" "catalogue" {
  identifier         = "catalogue-db"
  engine             = "mysql"
  instance_class     = var.db_instance_class
  allocated_storage  = var.db_allocated_storage
  max_allocated_storage = var.db_max_allocated_storage
  storage_type       = var.db_storage_type
  storage_encrypted = true      #  enable encryption
  kms_key_id        = null      # uses AWS-managed key
  skip_final_snapshot = true

  # 🔹 High Availability
  multi_az           = var.db_multi_az

  # Monitoring basic cloudwatch
  monitoring_interval      = 60  # seconds (can also set to 60 or 60 seconds for enhanced monitoring)
  monitoring_role_arn      = aws_iam_role.rds_monitoring_role.arn  # IAM role for monitoring (only needed if enhanced monitoring enabled)

  # 🔹 Credentials
  username           = var.db_username
  password           = var.db_password

  # 🔹 Networking
  db_subnet_group_name   = aws_db_subnet_group.db.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

}



# Create an IAM Role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "rds-monitoring-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

# Attach CloudWatch policy to allow RDS to put metrics and logs to CloudWatch
resource "aws_iam_policy" "rds_monitoring_policy" {
  name        = "rds-monitoring-policy"
  description = "Policy to allow RDS Enhanced Monitoring to push logs and metrics to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",  # Allows describing log streams
          "logs:PutLogEvents"         # Allows writing log events
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = "iam:PassRole"  # Allows RDS to pass this role for enhanced monitoring
        Resource = "*"
      }
    ]
  })
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy_attachment" "rds_monitoring_policy_attachment" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = aws_iam_policy.rds_monitoring_policy.arn
}

