
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

variable "image" {
  description = "Default image name to build droplet from"
  type        = string
}

variable "region" {
  description = "Region for this project and environment"
  type        = string
}

variable "timezone" {
  description  = "Default timezone to deploy infrastructure"
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

variable "ssh_port" {
  description = "Custom ssh port to change"
  type        = string
}

variable "ssh_config_host" {
  description = "CIDR regex for ssh config host"
  type        = string
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

variable "frontend_ip" {
  description = "IP address of frontend droplet"
  type        = string
}

variable "alert_email" {
  description  = "Send monitoring alerts to this email"
  type         = string
}

variable "services_ids" {
  description  = "Services droplets ids"
  type         = list
}

variable "frontend_id" {
  description  = "Frontend droplet id"
  type         = string
}
