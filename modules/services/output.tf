
output "services_ids" {
  description = "all services droplets ids"
  value       = values(digitalocean_droplet.services)[*].id
}

output "cache_droplet_id" {
  description = "redis cache droplet id"
  value       = digitalocean_droplet.services["cache"].id
}

output "session_droplet_id" {
  description = "redis session droplet id"
  value       = digitalocean_droplet.services["session"].id
}

output "cache_ip" {
  description = "redis cache private ip address"
  value       = digitalocean_droplet.services["cache"].ipv4_address_private
}

output "session_ip" {
  description = "redis session private ip address"
  value       = digitalocean_droplet.services["session"].ipv4_address_private
}

output "cache_droplet_status" {
  description = "redis cache droplet status"
  value       = digitalocean_droplet.services["cache"].status
}

output "session_droplet_status" {
  description = "redis session droplet status"
  value       = digitalocean_droplet.services["session"].status
}

output "media_droplet_id" {
  description = "media droplet id"
  value       = digitalocean_droplet.services["media"].id
}

output "media_ip" {
  description = "media private ip address"
  value       = digitalocean_droplet.services["media"].ipv4_address_private
}

output "media_droplet_status" {
  description = "media droplet status"
  value       = digitalocean_droplet.services["media"].status
}

output "elasticsearch_droplet_id" {
  description = "elasticsearch droplet id"
  value       = digitalocean_droplet.services["elasticsearch"].id
}

output "elasticsearch_ip" {
  description = "elasticsearch private ip address"
  value       = digitalocean_droplet.services["elasticsearch"].ipv4_address_private
}


output "elasticsearch_droplet_status" {
  description = "elasticsearch droplet status"
  value       = digitalocean_droplet.services["elasticsearch"].status
}
