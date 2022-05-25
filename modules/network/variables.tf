
variable "project_name" {
  description  = "The name of the project"
  type         = string
}

variable "project_id" {
  description  = "The id of the project"
  type         = string
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
