###################################
# Providers
###################################

terraform {
  required_providers {
    fmc = {
      source = "CiscoDevNet/fmc"
      version = ">=1.4.2"
    }
  }
}


provider "fmc" {
  is_cdfmc  = true
  cdo_token = var.cdo_token
  fmc_host  = var.cdFMC
  cdfmc_domain_uuid = var.cdfmc_domain_uuid
}
