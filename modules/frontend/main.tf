


//////////////////////////////////////////////////////[ FRONTEND WORKER ]/////////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create droplet for frontend worker
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_droplet" "frontend" {
  image         = data.digitalocean_images.packer.images[0].id
  name          = "${var.project.name}-frontend"
  region        = var.region
  size          = var.size
  monitoring    = var.monitoring
  backups       = var.backups
  vpc_uuid      = var.vpc_uuid
  ssh_keys      = [var.admin_ssh_key.id]
  resize_disk   = var.resize_disk
  droplet_agent = var.droplet_agent
  tags          = [
    digitalocean_tag.frontend.id,
    digitalocean_tag.frontend_loadbalancer.id
  ]
  user_data     = templatefile("${path.module}/user_data/frontend.yml", 
    { 
      ADMIN_SSH_KEY       = var.admin_ssh_key.public_key
      MANAGER_SSH_KEY     = var.manager_ssh_key.public_key
      TIMEZONE            = var.timezone
    }
  )
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for frontend droplet
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "frontend" {
  name     = "${var.project.name}-frontend"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for frontend droplet to connect for loadbalancer
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "frontend_loadbalancer" {
  name     = "loadbalancer"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign droplets to this project per environment
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "frontend" {
  project   = var.project.id
  resources = [
    digitalocean_droplet.frontend.urn
  ]
}
