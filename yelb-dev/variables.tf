##############
# Variables
##############

# Secure Firewall

# If creating FMCv in VPC then true, if using cdFMC then false.

variable "cdo_token" {
  type        = string
  sensitive   = true
}
variable "cdo_base_url" {
  type = string
  default = "https://www.defenseorchestrator.com"
}
variable "cdFMC" {
  description = "FQDN of cdFMC instance - pass this value using tfvars file"
  type        = string
  default     = ""
}

variable "cdfmc_domain_uuid" {
  type        = string
  default     = "e276abec-e0f2-11e3-8169-6d9ed49b625f"
}

variable "ftd_device_name" {
  type        = string
}

variable "access_policy_name" {
  description = "The name of the ACP to be referenced by the data source"
  type        = string
}

variable "ips_policy_name" {
  description = "The name of the IPS policy to be referenced by the data source"
  type        = string
}

variable "port_object_name" {
  description = "The name of the port object to be referenced by the data source"
  type        = string
}

variable "port_object_port" {
  description = "The network port used by the application"
  type        = number
}

variable "kube_egress_ip" {
  description = "The static egress gateway IP for Kubernetes Cluster"
  type        = string
}

variable "ftd_nat_ip" {
  description = "The IP address for inside FTD nat traffic"
  type        = string
}