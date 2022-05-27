
locals {
  
  cidr_regex      = regex("^[0-9]+.[0-9]+.", var.vpc_cidr)
  
  ssh_config_host = "${local.cidr_regex}.*.*"
  ssh_port        = random_integer.ssh_port.result
  
  manager_ssh_key = data.digitalocean_ssh_keys.manager.ssh_keys[0]
  admin_ssh_key   = data.digitalocean_ssh_keys.admin.ssh_keys[0]
  
  packer_snapshot = "packer-builder-frontend"
  
  domain          = var.domains[local.environment]
}
