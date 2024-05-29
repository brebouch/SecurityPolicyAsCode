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