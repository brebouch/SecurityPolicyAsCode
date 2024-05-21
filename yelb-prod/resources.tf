# Port Objects

resource "fmc_port_objects" "port_object" {
    name = var.port_object_name
    port = var.port_object_port
    protocol = "TCP"
}

# Deployment

resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_port_objects.port_object,]
    device = data.fmc_devices.ftd.id
    ignore_warning = false
    force_deploy = false
}