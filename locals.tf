
locals {

  manager_ssh_key = data.digitalocean_ssh_keys.manager.ssh_keys[0]
  admin_ssh_key   = data.digitalocean_ssh_keys.admin.ssh_keys[0]
  
  packer_snapshot = "packer-builder-frontend"
  
  domain          = var.domains[local.environment]
  
}
