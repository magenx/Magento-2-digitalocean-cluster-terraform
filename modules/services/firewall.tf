


///////////////////////////////////////////////////////[ FIREWALL ]///////////////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create firewall for services
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_firewall" "services" {
  for_each    = var.services
  name        = "${var.project.name}-${each.key}-firewall"
  droplet_ids = [digitalocean_droplet.services[each.key].id]
  tags        = [digitalocean_tag.services_firewall[each.key].id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = each.value.port
    source_addresses = [var.vpc_cidr]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["0.0.0.0/0"]
  }
  
  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["67.207.67.2","67.207.67.3"]
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for firewall
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "services_firewall" {
  for_each = var.services
  name     = "${var.project.name}-${each.key}-firewall"
}
