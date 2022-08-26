
output "frontend_id" {
  description = "frontend droplet id"
  value       = digitalocean_droplet.frontend.id
}

output "frontend_ip" {
  description = "frontend private ip address"
  value       = digitalocean_droplet.frontend.ipv4_address_private
}

output "frontend_status" {
  description = "frontend droplet status"
  value       = digitalocean_droplet.frontend.status
}
