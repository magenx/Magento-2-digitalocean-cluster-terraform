
variable "project" {
  description  = "The data of the project"
  type         = map
}

variable "vpc_cidr" {
  description  = "VPC network size"
  type         = string
}

variable "environment" {
  description  = "Environment selected to deploy this configuration to"
  type         = string
}

variable "region" {
  description  = "Region for this project and environment"
  type         = string
}
