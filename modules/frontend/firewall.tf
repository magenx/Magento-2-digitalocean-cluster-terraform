


///////////////////////////////////////////////////////[ FIREWALL ]///////////////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create firewall for frontend
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_firewall" "frontend" {
  name        = "${var.project.name}-frontend-firewall"
  droplet_ids = [digitalocean_droplet.frontend.id]
  tags        = [digitalocean_tag.frontend_firewall.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0"]
  }
  
  inbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    source_addresses = ["0.0.0.0/0"]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    destination_addresses = ["0.0.0.0/0"]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "443"
    destination_addresses = ["0.0.0.0/0"]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "6379"
    destination_addresses = [var.vpc_cidr]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "3306"
    destination_addresses = [var.vpc_cidr]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "9200"
    destination_addresses = [var.vpc_cidr]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "5672"
    destination_addresses = [var.vpc_cidr]
  }
  
  outbound_rule {
    protocol         = "tcp"
    port_range       = "2049"
    destination_addresses = [var.vpc_cidr]
  }
  
  outbound_rule {
    protocol         = "udp"
    port_range       = "2049"
    destination_addresses = [var.vpc_cidr]
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for frontend firewall
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "frontend_firewall" {
  name     = "${var.project.name}-frontend-firewall"
}
