


///////////////////////////////////////////////////////////[ PROJECT ]////////////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Define brand or business name
# # ---------------------------------------------------------------------------------------------------------------------#
variable "brand" {
   default = "magenx"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create hash number to assign to project name
# # ---------------------------------------------------------------------------------------------------------------------#
resource "random_string" "project" {
  length         = 7
  lower          = true
  number         = true
  special        = false
  upper          = false
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create global project name to be assigned per environment
# # ---------------------------------------------------------------------------------------------------------------------#
locals {
   project     = lower("${var.brand}-${random_string.project.result}")
   environment = lower(terraform.workspace)
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create project per environment
# # ---------------------------------------------------------------------------------------------------------------------#
resource "digitalocean_project" "this" {
  name        = "${local.project}-${local.environment}"
  description = "Project for ${local.project} ${local.environment}"
  purpose     = "Infrastructure for ${local.project} ${local.environment}"
  environment = title(local.environment)
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Get project name and project id from digitalocean resource
# # ---------------------------------------------------------------------------------------------------------------------#
locals {
   project_name = digitalocean_project.this.name
   project_id   = digitalocean_project.this.id
}


