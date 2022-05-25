
variable "project_name" {
  description  = "The name of the project"
  type         = string
}

variable "project_id" {
  description  = "The id of the project"
  type         = string
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
