


///////////////////////////////////////////////////[ RANDOM STRING GENERATOR ]////////////////////////////////////////////

# # ---------------------------------------------------------------------------------------------------------------------#
# Generate random password for services [database | redis | elasticsearch | rabbitmq]
# # ---------------------------------------------------------------------------------------------------------------------#
resource "random_password" "services" {
  for_each         = var.services
  length           = 16
  lower            = true
  upper            = true
  number           = true
  special          = true
  override_special = "%*?"
}
