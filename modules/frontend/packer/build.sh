#!/bin/bash

export _MAGENX_NGINX_REPO="https://raw.githubusercontent.com/magenx/Magento-nginx-config/master/"
export _MAGENX_NGINX_REPO_API="https://api.github.com/repos/magenx/Magento-nginx-config/contents/magento2"
export _PRIVATE_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

## installation
apt-get update
apt-get -qy upgrade
apt-get -qqy install nfs-common curl unzip git patch python3-pip acl attr imagemagick snmp

## create user
useradd -d /home/${BRAND} -s /sbin/nologin ${BRAND}
## create root php user
useradd -M -s /sbin/nologin -d /home/${BRAND} ${PHP_USER}
usermod -g ${PHP_USER} ${BRAND}
 
mkdir -p ${WEB_ROOT_PATH}
chmod 711 /home/${BRAND}
mkdir -p /home/${BRAND}/{.config,.cache,.local,.composer}
mkdir -p ${WEB_ROOT_PATH}/{pub/media,var}
chown -R ${BRAND}:${PHP_USER} ${WEB_ROOT_PATH}
chown -R ${BRAND}:${BRAND} /home/${BRAND}/{.config,.cache,.local,.composer}
chmod 2750 ${WEB_ROOT_PATH} /home/${BRAND}/{.config,.cache,.local,.composer}
setfacl -R -m m:rx,u:${BRAND}:rwX,g:${PHP_USER}:r-X,o::-,d:u:${BRAND}:rwX,d:g:${PHP_USER}:r-X,d:o::- ${WEB_ROOT_PATH}

## add NFS mount
echo "${MEDIA_IP}:${WEB_ROOT_PATH}/var ${WEB_ROOT_PATH}/var nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" >> /etc/fstab
echo "${MEDIA_IP}:${WEB_ROOT_PATH}/pub/media ${WEB_ROOT_PATH}/pub/media nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" >> /etc/fstab

## install nginx
curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list

## install php
wget -qO /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
_PHP_PACKAGES+=(${PHP_PACKAGES})

apt-get -qq update -o Dir::Etc::sourcelist="sources.list.d/nginx.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
apt-get -qq update -o Dir::Etc::sourcelist="sources.list.d/php.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

apt-get -qqy -o Dpkg::Options::="--force-confold" install nginx nginx-module-perl nginx-module-image-filter nginx-module-geoip php-pear php${PHP_VERSION} ${_PHP_PACKAGES[@]/#/php${PHP_VERSION}-}

setfacl -R -m u:nginx:r-X,d:u:nginx:r-X ${WEB_ROOT_PATH}

cat > /etc/sysctl.conf <<END
fs.file-max = 1000000
fs.inotify.max_user_watches = 1000000
vm.swappiness = 5
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.msgmnb = 65535
kernel.msgmax = 65535
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_mem = 8388608 8388608 8388608
net.ipv4.tcp_rmem = 4096 87380 8388608
net.ipv4.tcp_wmem = 4096 65535 8388608
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_challenge_ack_limit = 1073741823
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 15
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_max_tw_buckets = 400000
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2
net.ipv4.tcp_sack = 1
net.ipv4.route.flush = 1
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.rmem_default = 8388608
net.core.wmem_default = 8388608
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 65535
END

cat > ${php_fpm_pool_path}/${BRAND}.conf <<END
[${BRAND}]
;;
;; Pool user
user = php-\$pool
group = php-\$pool
listen = /var/run/\$pool.sock
listen.owner = nginx
listen.group = php-\$pool
listen.mode = 0660
;;
;; Pool size and settings
pm = ondemand
pm.max_children = 100
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
pm.max_requests = 10000
;;
;; [php ini] settings
php_admin_flag[expose_php] = Off
php_admin_flag[short_open_tag] = On
php_admin_flag[display_errors] = Off
php_admin_flag[log_errors] = On
php_admin_flag[mysql.allow_persistent] = On
php_admin_flag[mysqli.allow_persistent] = On
php_admin_value[default_charset] = "UTF-8"
php_admin_value[memory_limit] = 1024M
php_admin_value[max_execution_time] = 7200
php_admin_value[max_input_time] = 7200
php_admin_value[max_input_vars] = 50000
php_admin_value[post_max_size] = 64M
php_admin_value[upload_max_filesize] = 64M
php_admin_value[realpath_cache_size] = 4096k
php_admin_value[realpath_cache_ttl] = 86400
php_admin_value[session.gc_maxlifetime] = 28800
php_admin_value[error_log] = "/home/\$pool/public_html/var/log/php-fpm-error.log"
php_admin_value[date.timezone] = "${TIMEZONE}"
php_admin_value[upload_tmp_dir] = "/home/\$pool/public_html/var/tmp"
php_admin_value[sys_temp_dir] = "/home/\$pool/public_html/var/tmp"
;;
;; [opcache] settings
php_admin_flag[opcache.enable] = On
php_admin_flag[opcache.use_cwd] = On
php_admin_flag[opcache.validate_root] = On
php_admin_flag[opcache.revalidate_path] = Off
php_admin_flag[opcache.validate_timestamps] = Off
php_admin_flag[opcache.save_comments] = On
php_admin_flag[opcache.load_comments] = On
php_admin_flag[opcache.fast_shutdown] = On
php_admin_flag[opcache.enable_file_override] = Off
php_admin_flag[opcache.inherited_hack] = On
php_admin_flag[opcache.consistency_checks] = Off
php_admin_flag[opcache.protect_memory] = Off
php_admin_value[opcache.memory_consumption] = 512
php_admin_value[opcache.interned_strings_buffer] = 4
php_admin_value[opcache.max_accelerated_files] = 60000
php_admin_value[opcache.max_wasted_percentage] = 5
php_admin_value[opcache.file_update_protection] = 2
php_admin_value[opcache.optimization_level] = 0xffffffff
php_admin_value[opcache.blacklist_filename] = "/home/\$pool/opcache.blacklist"
php_admin_value[opcache.max_file_size] = 0
php_admin_value[opcache.force_restart_timeout] = 60
php_admin_value[opcache.error_log] = "/home/\$pool/public_html/var/log/opcache.log"
php_admin_value[opcache.log_verbosity_level] = 1
php_admin_value[opcache.preferred_memory_model] = ""
php_admin_value[opcache.jit_buffer_size] = 536870912
php_admin_value[opcache.jit] = 1235
END


cat > /etc/logrotate.d/magento <<END
${WEB_ROOT_PATH}/var/log/*.log
{
su ${BRAND} ${PHP_USER}
create 660 ${BRAND} ${PHP_USER}
daily
rotate 7
notifempty
missingok
compress
}
END

## nginx configuration
wget -qO /etc/nginx/fastcgi_params  ${_MAGENX_NGINX_REPO}magento2/fastcgi_params
wget -qO /etc/nginx/nginx.conf  ${_MAGENX_NGINX_REPO}magento2/nginx.conf
mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available && cd $_
curl -s ${_MAGENX_NGINX_REPO_API}/sites-available 2>&1 | awk -F'"' '/download_url/ {print $4 ; system("curl -sO "$4)}' >/dev/null
ln -s /etc/nginx/sites-available/magento2.conf /etc/nginx/sites-enabled/magento2.conf
mkdir -p /etc/nginx/conf_m2 && cd /etc/nginx/conf_m2/
curl -s ${_MAGENX_NGINX_REPO_API}/conf_m2 2>&1 | awk -F'"' '/download_url/ {print $4 ; system("curl -sO "$4)}' >/dev/null

sed -i "s/example.com/${DOMAIN}/g" /etc/nginx/sites-available/magento2.conf
sed -i "s/example.com/${DOMAIN}/g" /etc/nginx/nginx.conf

sed -i "s/set_real_ip_from 127.0.0.1/set_real_ip_from ${VPC_CIDR}/" /etc/nginx/nginx.conf
sed -i "s,/var/www/html,${WEB_ROOT_PATH}," /etc/nginx/conf_m2/maps.conf
 

