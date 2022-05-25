
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

variable "vpc_cidr" {
  description  = "VPC network size"
  type         = string
}

variable "region" {
  description  = "Region for this project and environment"
  type         = string
}
