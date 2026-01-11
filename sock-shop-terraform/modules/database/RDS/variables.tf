# -------------------
# DB Subnets
# -------------------
variable "db_subnet_ids" {
  description = "List of subnet IDs for the RDS DB subnet group"
  type        = list(string)
}

# VPC ID
variable "vpc_id" {
  type = string
}


# security groups to connect to the db
variable "security_groups" {
  type = list(string)
}

# -------------------
# DB Credentials
# -------------------
variable "db_username" {
  description = "Master username for RDS MySQL"
  type        = string
}

variable "db_password" {
  description = "Master password for RDS MySQL"
  type        = string
  sensitive   = true
}

# -------------------
# Optional: DB instance size & storage
# -------------------
variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.medium"
}

variable "db_allocated_storage" {
  description = "Initial allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Max allocated storage (GB)"
  type        = number
  default     = 200
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "db_storage_type" {
  description = "RDS storage type"
  type        = string
  default     = "gp3"
}
