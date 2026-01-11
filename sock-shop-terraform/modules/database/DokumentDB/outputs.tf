output "docdb_cluster_endpoint" {
  description = "Endpoint of the DocumentDB cluster"
  value       = aws_docdb_cluster.app_cluster.endpoint
}

output "docdb_cluster_id" {
  description = "DocumentDB cluster identifier"
  value       = aws_docdb_cluster.app_cluster.id
}

output "docdb_instance_ids" {
  description = "IDs of DocumentDB instances"
  value       = aws_docdb_cluster_instance.app_instances[*].id
}

output "logical_databases" {
  description = "Names of the logical databases in the cluster"
  value       = var.db_names
}
