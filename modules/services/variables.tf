
variable "project" {
  description  = "The data of the project"
  type         = map
}

variable "environment" {
  description  = "Environment selected to deploy this configuration to"
  type         = string
}

variable "brand" {
  description  = "Business name or brand name for this infrastructure"
  type         = string
}

variable "region" {
  description  = "Region for this project and environment"
  type         = string
}

variable "timezone" {
  description  = "Default timezone to deploy infrastructure"
  type         = string
}

variable "services" {
  description  = "Services parameters"
  type         = map
}

variable "image" {
  description = "Default image name to build droplet from"
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

variable "mariadb_version" {
  description = "MariaDB version to use"
  type        = string
}

variable "elk_version" {
  description = "Elasticsearch version to use"
  type        = string
}

variable "rabbitmq_version" {
  description = "RabbitMQ version to use"
  type        = string
}
