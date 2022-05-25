
variable "project" {
  description  = "The data of the project"
  type         = map
}

variable "environment" {
  description = "Environment selected to deploy this configuration to"
  type        = string
}

variable "vpc_uuid" {
  description  = "VPC_UUID"
  type         = string
}

variable "region" {
  description  = "Region for this project and environment"
  type         = string
}

variable "size" {
  description  = "The size of this load balancer"
  type         = string
}

variable "algorithm" {
  description  = "Load balancer algorithm to distribute traffic"
  type         = string
}

locals {
   domains_list = csvdecode(file("${path.module}/domains.csv"))
   domain       = local.domains_list[0]["${var.environment}"]
}
