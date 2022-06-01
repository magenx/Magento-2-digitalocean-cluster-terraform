


////////////////////////////////////////////////////////[ SERVICES DROPLETS ]//////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Create droplet for services
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_droplet" "services" {
  for_each      = var.services
  image         = var.image
  name          = "${var.project.name}-${each.key}"
  region        = var.region
  size          = each.value.size
  monitoring    = var.monitoring
  backups       = var.backups
  vpc_uuid      = var.vpc_uuid
  droplet_agent = var.droplet_agent
  ssh_keys      = [var.admin_ssh_key.id]
  tags          = [digitalocean_tag.services[each.key].id]
  volume_ids    = each.key == "media" ? [digitalocean_volume.media.id] : null
  user_data     = templatefile("${path.module}/user_data/template.yml", {
                    service        = each.key
                    domain         = var.domain
                    timezone       = var.timezone
                    ssh_users      = local.ssh_users
                    service_config = local.cloudinit_for_service[each.key]
                  }
                )
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create tag for services droplets
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_tag" "services" {
  for_each = var.services
  name     = "${var.project.name}-${each.key}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create volume for media droplet storage
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_volume" "media" {
  region                  = var.region
  name                    = "${var.project.name}-media-volume"
  size                    = var.services.media.volume
  initial_filesystem_type = "ext4"
  description             = "Volume for media droplet @ ${var.project.name}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Assign services droplets with volume to this project
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project_resources" "services" {
  project   = var.project.id
  resources = concat(values(digitalocean_droplet.services)[*].urn,[digitalocean_volume.media.urn])
}


