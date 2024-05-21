# Port Object Details

# Dev

output "dev_port_name" {
  description = "Dev Port Object Name"
  value       = fmc_port_objects.dev.name
}

output "dev_port_id" {
  description = "Dev Port Object ID"
  value       = fmc_port_objects.dev.id
}

output "dev_port_port" {
  description = "Dev Port Object ID"
  value       = fmc_port_objects.dev.port
}

output "dev_port_protocol" {
  description = "Dev Port Object Protocol"
  value       = fmc_port_objects.dev.protocol
}

# Prod

output "prod_port_name" {
  description = "Prod Port Object Name"
  value       = fmc_port_objects.prod.name
}

output "prod_port_id" {
  description = "Prod Port Object ID"
  value       = fmc_port_objects.prod.id
}

output "prod_port_port" {
  description = "Prod Port Object ID"
  value       = fmc_port_objects.prod.port
}

output "prod_port_protocol" {
  description = "Prod Port Object Protocol"
  value       = fmc_port_objects.prod.protocol
}
