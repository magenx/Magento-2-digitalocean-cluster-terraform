# packer digitalocean
# pre-build custom image
# # ---------------------------------------------------------------------------------------------------------------------#
# Set packer digitalocean plugin version
# # ---------------------------------------------------------------------------------------------------------------------#
packer {
  required_plugins {
    digitalocean = {
      version = ">= 1.0.4"
      source  = "github.com/hashicorp/digitalocean"
    }
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Packer variables
# # ---------------------------------------------------------------------------------------------------------------------#
variable "token" {
  default = env("DIGITALOCEAN_ACCESS_TOKEN")
}
variable "size" {}
variable "region" {}
variable "image" {}
variable "project_name" {}
variable "packer_snapshot" {}
variable "vpc_default_id" {}

variable "BRAND" {}
variable "PHP_USER" {}
variable "WEB_ROOT_PATH" {}
variable "MEDIA_IP" {}
variable "PHP_PACKAGES" {}
variable "PHP_VERSION" {}
variable "TIMEZONE" {}
variable "VPC_CIDR" {}
variable "DOMAIN" {}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create Packer Builder
# # ---------------------------------------------------------------------------------------------------------------------#
source "digitalocean" "latest-image" {
  api_token    = var.token
  image        = var.image
  region       = var.region
  size         = var.size
  vpc_uuid     = var.vpc_default_id
  ssh_username = "root"
  
  private_networking      = true
  connect_with_private_ip = true
  
  snapshot_name    = "${var.packer_snapshot}-${var.project_name}-${local.timestamp}"
  snapshot_regions = [var.region]
  droplet_name     = "${var.project_name}-${var.packer_snapshot}"
}

build {
  name    = "latest-image"
  sources = [
    "source.digitalocean.latest-image"
  ]
  
provisioner "shell" {
  script       = "./build.sh"
  pause_before = "10s"
  timeout      = "60s"
  
  environment_vars = [
    "BRAND=${var.BRAND}",
    "PHP_USER=${var.PHP_USER}",
    "WEB_ROOT_PATH=${var.WEB_ROOT_PATH}",
    "MEDIA_IP=${var.MEDIA_IP}",
    "PHP_PACKAGES=${var.PHP_PACKAGES}",
    "PHP_VERSION=${var.PHP_VERSION}",
    "TIMEZONE=${var.TIMEZONE}",
    "VPC_CIDR=${var.VPC_CIDR}",
    "DOMAIN=${var.DOMAIN}",
    "PHP_FPM_POOL=/etc/php/${var.PHP_VERSION}/fpm/pool.d/${BRAND}.conf",
  ]
 }
  
  provisioner "shell" {
  script       = "./cleanup.sh"
  pause_before = "10s"
  timeout      = "120s"
 }
  
}

