


//////////////////////////////////////////////////[ MANAGER MASTER DROPLET ]//////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create manager master droplet to control infrastructure [workaround for missing service]
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_droplet" "manager" {
  image         = var.image
  name          = "${var.project.name}-manager"
  region        = var.region
  size          = var.size
  monitoring    = var.monitoring
  backups       = var.backups
  vpc_uuid      = var.vpc_uuid
  ssh_keys      = [var.admin_ssh_key.id,var.manager_ssh_key.id]
  droplet_agent = var.droplet_agent
  tags          = [digitalocean_tag.manager.id]
  user_data     = templatefile("${path.module}/user_data/manager.yml", 
    { 
      MANAGER_SSH_KEY  = var.manager_ssh_key.public_key
      ADMIN_SSH_KEY    = var.admin_ssh_key.public_key
      VPC_CIDR         = var.vpc_cidr
      create_droplet   = local.cloudinit_for_manager.create_droplet
      delete_droplet   = local.cloudinit_for_manager.delete_droplet
    }
  )
}

# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for manager master droplet
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "manager" {
  name = "${var.project.name}-manager"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign droplets to this project per environment
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "manager" {
  project   = var.project.id
  resources = [
    digitalocean_droplet.manager.urn
  ]
}
