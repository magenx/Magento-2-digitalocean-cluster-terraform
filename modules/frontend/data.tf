
# # ---------------------------------------------------------------------------------------------------------------------#
# Get default vpc
# # ---------------------------------------------------------------------------------------------------------------------#
data "digitalocean_vpc" "default" {
  name = "default-${var.region}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Get default official image data
# # ---------------------------------------------------------------------------------------------------------------------#
data "digitalocean_image" "default" {
  slug = var.image
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Get packer builder snapshot data
# # ---------------------------------------------------------------------------------------------------------------------#
data "digitalocean_images" "packer" {
  depends_on = [null_resource.packer]

  filter {
    key      = "private"
    values   = ["true"]
  }
  filter {
    key      = "regions"
    values   = [var.region]
  }  
  filter {
    key      = "name"
    values   = ["${var.packer.snapshot}-${var.project.name}"]
    match_by = "re"
  }
  sort {
    key       = "created"
    direction = "desc"
  }
}

