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