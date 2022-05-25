
locals {
 ## user data to configure auto scaling droplet
 user_data       = templatefile("${path.module}/droplet/user_data.sh",
      {}
    )
 
 cloudinit_for_manager = {
    ## cloudinit create droplet configuration template
    create_droplet    = templatefile("${path.module}/droplet/create_droplet.sh",
      {
        SIZE        = var.size
        IMAGE       = var.image
        REGION      = var.region
        DOMAIN      = var.domain
        PROJECT     = var.project.name
        ALERT_EMAIL = var.alert_email
        USER_DATA   = local.user_data
        SSH_PORT    = var.ssh_port
        SSH_KEYS    = "[var.admin_ssh_key.id,var.manager_ssh_key.id]"
        VPC_UUID    = var.vpc_uuid
        FRONTEND_IP = var.frontend_ip
      }
    )
    ## cloudinit delete droplet configuration template
    delete_droplet    = templatefile("${path.module}/droplet/delete_droplet.sh",
      {}
    )
 }
}
