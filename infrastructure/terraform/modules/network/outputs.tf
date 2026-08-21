output "vpc_id" {
  description = "ID of the application VPC."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = [for index in range(2) : aws_subnet.public[index].id]
}

output "private_db_subnet_ids" {
  description = "IDs of the private database subnets."
  value       = [for index in range(2) : aws_subnet.private_db[index].id]
}

output "availability_zones" {
  description = "Availability zones used by the network."
  value       = var.availability_zones
}

output "internet_gateway_id" {
  description = "ID of the VPC internet gateway."
  value       = aws_internet_gateway.this.id
}
