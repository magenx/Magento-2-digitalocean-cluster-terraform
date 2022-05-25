

output "vpc_uuid" {
  description = "VPC_UUID"
  value = digitalocean_vpc.this.id
}
