


////////////////////////////////////////////////[ INFRASTRUCTURE DEPLOYMENT ]/////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create VPC and base networking layout
# # ---------------------------------------------------------------------------------------------------------------------#
module "network" {
  source       = "./modules/network"
  project      = local.project
  vpc_cidr     = var.vpc_cidr
  region       = var.region
}

# # ---------------------------------------------------------------------------------------------------------------------#
# Create load balancer with domain and dns settings + ssl letsencrypt
# # ---------------------------------------------------------------------------------------------------------------------#
module "loadbalancer" {
  source           = "./modules/loadbalancer"
  project          = local.project
  region           = var.region
  vpc_uuid         = module.network.vpc_uuid
  size             = var.loadbalancer.size
  algorithm        = "round_robin"
  alert_email      = var.alert_email
  domain           = local.domain
}

# # ---------------------------------------------------------------------------------------------------------------------#
# Create manager droplet to control auto scaling and manage services droplets
# # ---------------------------------------------------------------------------------------------------------------------#
module "manager" {
  source          = "./modules/manager"
  project         = local.project
  vpc_uuid        = module.network.vpc_uuid
  vpc_cidr        = var.vpc_cidr
  image           = var.default_image
  region          = var.region
  size            = var.manager.size
  monitoring      = var.monitoring
  backups         = var.backups
  droplet_agent   = var.droplet_agent
  admin_ssh_key   = local.admin_ssh_key
  manager_ssh_key = local.manager_ssh_key
  timezone        = var.timezone
  domain          = local.domain
  alert_email     = var.alert_email
  services_ids    = module.services.services_ids
}
  
# # ---------------------------------------------------------------------------------------------------------------------#
# Create services [database | redis | elasticsearch | rabbitmq]
# # ---------------------------------------------------------------------------------------------------------------------#
module "services" {
  source          = "./modules/services"
  services        = var.services
  project         = local.project
  image           = var.default_image
  region          = var.region
  monitoring      = var.monitoring
  backups         = var.backups
  vpc_uuid        = module.network.vpc_uuid
  vpc_cidr        = var.vpc_cidr
  droplet_agent   = var.droplet_agent
  admin_ssh_key   = local.admin_ssh_key
  manager_ssh_key = local.manager_ssh_key
  ## app variables
  domain           = local.domain
  brand            = var.brand
  elk_version      = var.elk_version
  mariadb_version  = var.mariadb_version
  rabbitmq_version = var.rabbitmq_version
  timezone         = var.timezone
}
  
# # ---------------------------------------------------------------------------------------------------------------------#
# Create frontend worker
# # ---------------------------------------------------------------------------------------------------------------------#
module "frontend" {
  source          = "./modules/frontend"
  project         = local.project
  image           = var.default_image
  region          = var.region
  size            = var.frontend.size
  resize_disk     = var.resize_disk
  monitoring      = var.monitoring
  backups         = var.backups
  vpc_uuid        = module.network.vpc_uuid
  vpc_cidr        = var.vpc_cidr
  droplet_agent   = var.droplet_agent
  admin_ssh_key   = local.admin_ssh_key
  manager_ssh_key = local.manager_ssh_key
  timezone        = var.timezone
  php_version     = var.php_version
  php_packages    = var.php_packages
  varnish_version = var.varnish_version
  domain          = local.domain
  media_ip        = module.services.media_ip
  brand           = var.brand
  packer          = var.packer
}
  
  
