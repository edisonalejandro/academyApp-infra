output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "db_endpoint" {
  description = "Endpoint of the RDS PostgreSQL instance"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "cache_endpoint" {
  description = "Endpoint of the ElastiCache Redis cluster"
  value       = aws_elasticache_cluster.main.cache_nodes[0].address
}

output "public_subnet_ids" {
  description = "IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of private subnets"
  value       = aws_subnet.private[*].id
}
