output "subnet" {
  value       = aws_subnet.myapp-subnet-1
}

output "route_table_id"{
  description = "the ID of the rout table"
  value = aws_route_table.myapp-route-table.id
}