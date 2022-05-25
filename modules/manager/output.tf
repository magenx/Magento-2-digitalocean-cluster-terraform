
output "droplet_id" {
  description = "manager droplet id"
  value       = digitalocean_droplet.manager.id
}

output "private_ip" {
  description = "manager private ip address"
  value       = digitalocean_droplet.manager.ipv4_address_private
}

output "droplet_status" {
  description = "manager droplet status"
  value       = digitalocean_droplet.manager.status
}
