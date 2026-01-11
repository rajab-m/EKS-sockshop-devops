variable "docdb_user" {
  description = "Master username for DocumentDB cluster"
  type        = string
}

# VPC ID
variable "vpc_id" {
  type = string
}


# security groups to connect to the db
variable "security_groups" {
  type = list(string)
}

variable "docdb_pass" {
  description = "Master password for DocumentDB cluster"
  type        = string
  sensitive   = true
}

variable "db_names" {
  description = "Logical database names inside the cluster"
  type        = map(string)
  default = {
    carts  = "carts"
    users  = "users"
    orders = "orders"
  }
}

# DB Subnets
# -------------------
variable "db_subnet_ids" {
  description = "List of subnet IDs for the RDS DB subnet group"
  type        = list(string)
}
