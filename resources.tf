# Port Objects

resource "fmc_port_objects" "prod" {
    depends_on = [data.fmc_port_objects.prod]
    name = var.prod_port_object_name
    port = var.prod_port_object_port
    protocol = "TCP"
}

resource "fmc_port_objects" "dev" {
    depends_on = [data.fmc_port_objects.dev]
    name = var.dev_port_object_name
    port = var.dev_port_object_port
    protocol = "TCP"
}

# Deployment

resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_port_objects.dev, fmc_port_objects.prod]
    device = data.fmc_devices.ftd.id
    ignore_warning = false
    force_deploy = false
}