# RDS Endpoint
output "catalogue_db_endpoint" {
  description = "Endpoint of the RDS MySQL catalogue database"
  value       = aws_db_instance.catalogue.endpoint
}

# RDS Port
output "catalogue_db_port" {
  description = "Port of the RDS MySQL catalogue database"
  value       = aws_db_instance.catalogue.port
}

# RDS Instance Identifier
output "catalogue_db_identifier" {
  description = "Identifier of the RDS MySQL instance"
  value       = aws_db_instance.catalogue.id
}

# DB Subnet Group Name
output "catalogue_db_subnet_group" {
  description = "Name of the DB subnet group"
  value       = aws_db_subnet_group.db.name
}
