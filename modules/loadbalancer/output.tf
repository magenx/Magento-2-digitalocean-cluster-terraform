
output "loadbalancer_id" {
  description = "loadbalancer id"
  value       = digitalocean_loadbalancer.this.id
}

output "loadbalancer_ip" {
  description = "loadbalancer ip address"
  value       = digitalocean_loadbalancer.this.ip
}

output "loadbalancer_urn" {
  description = "loadbalancer private ip address"
  value       = digitalocean_loadbalancer.this.urn
}

output "certificate_id" {
  description = "certificate id"
  value       = digitalocean_certificate.this.id
}

output "certificate_uuid" {
  description = "certificate uuid"
  value       = digitalocean_certificate.this.uuid
}

output "certificate_name" {
  description = "certificate name"
  value       = digitalocean_certificate.this.name
}

output "certificate_expire" {
  description = "certificate expiry date"
  value       = digitalocean_certificate.this.not_after
}

