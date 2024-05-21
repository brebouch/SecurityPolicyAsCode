# Port Objects

data "fmc_port_objects" "dev" {
    name = var.dev_port_object_name
}

data "fmc_port_objects" "prod" {
    name = var.prod_port_object_name
}

# FTD Device

data "fmc_devices" "ftd" {
    name = var.ftd_device_name
}