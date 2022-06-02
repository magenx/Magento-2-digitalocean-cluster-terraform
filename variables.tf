
variable "region" {
  ## https://docs.digitalocean.com/products/platform/availability-matrix/
  description  = "Default region to deploy infrastructure"
  default = "fra1"
}

variable "timezone" {
  description  = "Default timezone to deploy infrastructure"
  default = "Europe/Berlin"
}

variable "vpc_cidr" {
  description  = "VPC cidr network size"
  default = "10.35.0.0/16"
}

variable "domains" {
  description  = "Domains map per environment production | development"
  type         = map
}

variable "alert_email" {
  description  = "Send monitoring alerts to this email"
  type         = string
}

variable "admin_email" {
  description  = "Send magento related messages to this email"
  type         = string
}

variable "default_image" {
  description  = "Create services droplets and packer build from this base default official image"
  default = "debian-11-x64"
}

variable "loadbalancer" {
  description = "Load balancer size lb-small, lb-medium, or lb-large"
  default     = {
    size      = "lb-small"
  }
}

variable "services" {
  description  = "Settings for service droplets"
  default      = {
    elasticsearch = {
      size = "s-1vcpu-2gb-intel"
      port = "9200"
    }
    database      = {
      size = "s-1vcpu-2gb-intel"
      port = "3306"
    }
    rabbitmq      = {
      size = "s-1vcpu-1gb-intel"
      port = "5672"
    }
    cache         = {
      size = "s-1vcpu-1gb-intel"
      port = "6379"
    }
    session       = {
      size = "s-1vcpu-1gb-intel"
      port = "6379"
    }
    media         = {
      size   = "s-1vcpu-1gb-intel"
      port   = "2049"
      volume = "100"
    }
  }
}

variable "resize_disk" {
  description = "Disable or enable disk resize"
  default     = false
}

variable "packer" {
  description = "The size slug of packer build droplet"
  default      = {
    snapshot   = "packer-builder-frontend"
    size       = "s-1vcpu-1gb-intel"
  }
}

variable "frontend" {
  description  = "Size for frontend droplet"
  default      = {
    size       = "s-2vcpu-2gb-intel"
  }
}

variable "manager" {
  description  = "Size for manager droplet"
  default      =   {
    size       = "s-1vcpu-2gb-intel"
  }
}

variable "monitoring" {
  description = "Enable droplet monitoring"
  default     = true
}

variable "backups" {
  description = "Enable droplet backups"
  default     = true
}

variable "droplet_agent" {
  description = "Force droplet agent error"
  default     = true
}

variable "php_version" {
  description = "PHP version to use"
  default     = "8.1"
}

variable "varnish_version" {
  description = "Varnish version to use"
  default     = "70"
}

variable "elk_version" {
  description = "Elasticsearch version to use"
  default     = "7.17"
}

variable "mariadb_version" {
  description = "MariaDB version to use"
  default     = "10.5.16"
}

variable "rabbitmq_version" {
  description = "RabbitMQ version to use"
  default     = "3.8"
}

variable "php_packages" {
  description = "PHP package to install"
  default     = "cli fpm common mysql zip gd mbstring curl xml bcmath intl soap oauth lz4 apcu"
}



