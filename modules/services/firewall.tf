


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
    port_range       = var.ssh_port
    source_addresses = [var.vpc_cidr]
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
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for firewall
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "services_firewall" {
  for_each = var.services
  name     = "${var.project.name}-${each.key}-firewall"
}
