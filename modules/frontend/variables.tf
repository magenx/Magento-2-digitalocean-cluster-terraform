
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

variable "packer" {
  description  = "The name of packer builder final snapshot"
  type         = map
}

variable "region" {
  description  = "Region for this project and environment"
  type         = string
}

variable "timezone" {
  description  = "Default timezone to deploy infrastructure"
  type         = string
}

variable "brand" {
  description  = "Business name or brand name for this infrastructure"
  type         = string
}

variable "image" {
  description = "Default image name to build droplet from"
  type        = string
}

variable "size" {
  description = "The size slug of this droplet"
  type        = string
}

variable "monitoring" {
  description = "Enable monitoring for droplet"
  type        = bool
}

variable "backups" {
  description = "The name of the project"
  type        = bool
}

variable "vpc_uuid" {
  description = "UUID of vpc for this project and environment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC network size for this project"
  type        = string
}

variable "droplet_agent" {
  description = "Force droplet agent error"
  type        = bool
}

variable "manager_ssh_key" {
  description = "Public ssh key for manager user"
  type        = map
}

variable "admin_ssh_key" {
  description = "Public ssh key for admin user"
  type        = map
}

variable "domain" {
  description = "Domain name for this environment"
  type        = string
}

variable "media_ip" {
  description = "Media droplet private ip address"
  type        = string
}

variable "php_version" {
  description = "PHP version to install"
  type        = string
}

variable "php_packages" {
  description = "PHP packages to install"
  type        = string
}

variable "varnish_version" {
  description = "Varnish version to install"
  type        = string
}
