# FTD Device

data "fmc_devices" "ftd" {
    name = var.ftd_device_name
}

# IPS Policy
data "fmc_ips_policies" "ips_base_policy" {
    name = var.ips_policy_name
}

# Access Policy
data "fmc_access_policies" "access_policy" {
    name = var.access_policy_name
}

# Kube Egress Host Objects
data "fmc_host_objects" "kube_egress_ip" {
  name        = "kube_egress_ip"
}

# Host Objects
data "fmc_host_objects" "ftd_nat_ip" {
  name        = "ftd_nat_ip"
}