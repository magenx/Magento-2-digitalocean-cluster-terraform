
locals {
  ## cloudinit ssh users template 
  ssh_users         = templatefile("${path.module}/user_data/ssh_users.yml", 
  {
    ADMIN_SSH_KEY   = var.admin_ssh_key.public_key
    MANAGER_SSH_KEY = var.manager_ssh_key.public_key
  }
)
  ## cloudinit ssh config template
  ssh_config        = templatefile("${path.module}/user_data/ssh_config.yml", 
  {
    SSH_PORT        = var.ssh_port
    SSH_CONFIG_HOST = var.ssh_config_host
  }
)
  
  cloudinit_for_service = {
    ## cloudinit media configuration template
    media             = templatefile("${path.module}/user_data/media.yml",
      {
        VPC_CIDR      = var.vpc_cidr
        WEB_ROOT_PATH = "/home/${var.brand}/public_html"
        PHP_USER      = "php-${var.brand}"
        BRAND         = var.brand
        VOLUME_NAME   = digitalocean_volume.media.name
      }
    )
    ## cloudinit elasticsearch configuration template
    elasticsearch    = templatefile("${path.module}/user_data/elasticsearch.yml",
      {
        ELK_VERSION  = var.elk_version
        ELK_PASSWORD = random_password.services["elasticsearch"].result
      }
    )
    ## cloudinit database configuration template
    database               = templatefile("${path.module}/user_data/database.yml",
      {
        MARIADB_VERSION    = var.mariadb_version
        DATABASE_USER_NAME = var.brand
        DATABASE_NAME      = "${var.brand}_${var.environment}"
        DATABASE_PASSWORD  = random_password.services["database"].result
      }
    )
    ## cloudinit rabbitmq configuration template
    rabbitmq              = templatefile("${path.module}/user_data/rabbitmq.yml",
      {
        RABBITMQ_VERSION  = var.rabbitmq_version
        RABBITMQ_PASSWORD = random_password.services["rabbitmq"].result
      }
    )
    ## cloudinit cache configuration template
    cache                 = templatefile("${path.module}/user_data/cache.yml",
      {}
    )
    ## cloudinit cache configuration template
    session                 = templatefile("${path.module}/user_data/session.yml",
      {}
    )
  }
}

