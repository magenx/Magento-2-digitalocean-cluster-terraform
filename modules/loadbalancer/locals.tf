
locals {
   domains_list = csvdecode(file("${path.module}/domains.csv"))
   domain       = local.domains_list[0]["${lower(var.project.environment)}"]
}
