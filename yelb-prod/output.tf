# Port Object Details

output "port_name" {
  description = "Port Object Name"
  value       = fmc_port_objects.port_object.name
}

output "port_id" {
  description = "Port Object ID"
  value       = fmc_port_objects.port_object.id
}

output "port_port" {
  description = "Port Object ID"
  value       = fmc_port_objects.port_object.port
}

output "port_protocol" {
  description = "Port Object Protocol"
  value       = fmc_port_objects.port_object.protocol
}

