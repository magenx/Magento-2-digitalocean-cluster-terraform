


//////////////////////////////////////////////////////[ PACKER BUILDER ]//////////////////////////////////////////////////


# # ---------------------------------------------------------------------------------------------------------------------#
# Create custom image with Packer Builder
# # ---------------------------------------------------------------------------------------------------------------------#
resource "null_resource" "packer" {
  provisioner "local-exec" {
    working_dir = "${path.module}/packer"
    command = <<EOF
PACKER_LOG=1 PACKER_LOG_PATH="packerlog" /usr/bin/packer build \
-var size="${var.packer_size}" \
-var image="${data.digitalocean_image.default.slug}" \
-var region="${var.region}" \
-var vpc_default_id="${data.digitalocean_vpc.default.id}" \
-var project_name="${var.project_name}" \
-var packer_snapshot="${var.packer_snapshot}" \
-var BRAND="${var.brand}" \
-var PHP_USER="php-${var.brand}" \
-var WEB_ROOT_PATH="/home/${var.brand}/public_html" \
-var MEDIA_IP="${var.media_ip}" \
-var PHP_PACKAGES="${var.php_packages}" \
-var PHP_VERSION="${var.php_version}" \
-var TIMEZONE="${var.timezone}" \
-var VARNISH_VERSION="${var.varnish_version}" \
-var VPC_CIDR="${var.vpc_cidr}" \
-var DOMAIN="${var.domain}" packer.pkr.hcl
EOF
  }

 triggers = {
    image_creation_date = data.digitalocean_image.default.created
    build_script        = filesha256("${path.module}/packer/build.sh")
  }
}

