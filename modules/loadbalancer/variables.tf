
variable "project" {
  description  = "The data of the project"
  type         = object({
    created_at   = string
    description  = string
    environment  = string
    id           = string
    is_default   = bool
    name         = string
    owner_id     = number
    owner_uuid   = string
    purpose      = string
    resources    = set(string)
    updated_at   = string 
})
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

variable "alert_email" {
  description  = "Send monitoring alerts to this email"
  type         = string
}

variable "domain" {
  description  = "Domain name per environment for this project"
  type         = string
}

