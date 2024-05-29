# Port Objects

resource "fmc_port_objects" "port_object" {
    name = var.port_object_name
    port = var.port_object_port
    protocol = "TCP"
}


# Kube Egress Host Objects
resource "fmc_host_objects" "kube_egress_ip" {
  name        = "kube_egress_ip"
  value       = var.kube_egress_ip
  description = "Kubernetes Egress IP"
}



# Host Objects
resource "fmc_host_objects" "ftd_nat_ip" {
  name        = "ftd_nat_ip"
  value       = var.ftd_nat_ip
  description = "FTD Inside NAT IP"
}

resource "fmc_access_rules" "access_rule" {
  depends_on = [data.fmc_devices.ftd]
  acp                = data.fmc_access_policies.access_policy.id
  section            = "mandatory"
  name               = "${var.port_object_name} HTTP Access to Kube Egress"
  action             = "allow"
  enabled            = true
  send_events_to_fmc = true
  log_files          = false
  log_begin          = true
  log_end            = true
  source_networks {
    source_network {
      id   = fmc_host_objects.ftd_nat_ip.id
      type = "Host"
    }
  }
  destination_networks {
    destination_network {
      id   = fmc_host_objects.kube_egress_ip.id
      type = "Host"
    }
  }
  destination_ports {
    destination_port {
      id   = fmc_port_objects.port_object.id
      type = "TCPPortObject"
    }
  }
  ips_policy   = data.fmc_ips_policies.ips_base_policy.id
  new_comments = ["HTTP traffic to kubernetes"]
}

# Deployment

resource "fmc_ftd_deploy" "ftd" {
    depends_on = [fmc_port_objects.port_object,]
    device = data.fmc_devices.ftd.id
    ignore_warning = false
    force_deploy = false
}