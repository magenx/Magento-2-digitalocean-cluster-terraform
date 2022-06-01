


///////////////////////////////////////////////////////[ FIREWALL ]///////////////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create firewall for manager master droplet
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_firewall" "manager" {
  name        = "${var.project.name}-manager-firewall"
  droplet_ids = [digitalocean_droplet.manager.id]
  tags        = [digitalocean_tag.manager_firewall.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
  
  outbound_rule {
    protocol         = "udp"
    port_range       = "53"
    destination_addresses = ["67.207.67.2","67.207.67.3"]
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for manager firewall
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "manager_firewall" {
  name = "${var.project.name}-manager-firewall"
}
