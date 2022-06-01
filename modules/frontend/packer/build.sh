#!/bin/bash

export _MAGENX_NGINX_REPO="https://raw.githubusercontent.com/magenx/Magento-nginx-config/master/"
export _MAGENX_NGINX_REPO_API="https://api.github.com/repos/magenx/Magento-nginx-config/contents/magento2"
export _PRIVATE_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/private/0/ipv4/address)

## installation
apt-get update
apt-get -qqy install nfs-common unzip git patch python3-pip acl attr imagemagick snmp

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

## install varnish
curl -s https://packagecloud.io/install/repositories/varnishcache/varnish${VARNISH_VERSION}/script.deb.sh | bash

apt-get -qq update -o Dir::Etc::sourcelist="sources.list.d/nginx.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
apt-get -qq update -o Dir::Etc::sourcelist="sources.list.d/php.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
apt-get -qq update -o Dir::Etc::sourcelist="sources.list.d/varnishcache_varnish${VARNISH_VERSION}.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

apt-get -qqy install varnish nginx php-pear php${PHP_VERSION} ${_PHP_PACKAGES[@]/#/php${PHP_VERSION}-}

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

cat > ${PHP_OPCACHE_INI} <<END
zend_extension=opcache.so
opcache.enable = 1
opcache.enable_cli = 1
opcache.memory_consumption = 512
opcache.interned_strings_buffer = 4
opcache.max_accelerated_files = 60000
opcache.max_wasted_percentage = 5
opcache.use_cwd = 1
opcache.validate_timestamps = 0
;opcache.revalidate_freq = 2
;opcache.validate_permission = 1
opcache.validate_root = 1
opcache.file_update_protection = 2
opcache.revalidate_path = 0
opcache.save_comments = 1
opcache.load_comments = 1
opcache.fast_shutdown = 1
opcache.enable_file_override = 0
opcache.optimization_level = 0xffffffff
opcache.inherited_hack = 1
opcache.max_file_size = 0
opcache.consistency_checks = 0
opcache.force_restart_timeout = 60
opcache.error_log = "/var/log/php-fpm/opcache.log"
opcache.log_verbosity_level = 1
opcache.preferred_memory_model = ""
opcache.protect_memory = 0
;opcache.mmap_base = ""
END

cp ${PHP_INI} ${PHP_INI}.BACK
sed -i 's/^\(max_execution_time = \)[0-9]*/\17200/' ${PHP_INI}
sed -i 's/^\(max_input_time = \)[0-9]*/\17200/' ${PHP_INI}
sed -i 's/^\(memory_limit = \)[0-9]*M/\11048M/' ${PHP_INI}
sed -i 's/^\(post_max_size = \)[0-9]*M/\164M/' ${PHP_INI}
sed -i 's/^\(upload_max_filesize = \)[0-9]*M/\132M/' ${PHP_INI}
sed -i 's/expose_php = On/expose_php = Off/' ${PHP_INI}
sed -i 's/;realpath_cache_size =.*/realpath_cache_size = 5M/' ${PHP_INI}
sed -i 's/;realpath_cache_ttl =.*/realpath_cache_ttl = 86400/' ${PHP_INI}
sed -i 's/short_open_tag = Off/short_open_tag = On/' ${PHP_INI}
sed -i 's/;max_input_vars =.*/max_input_vars = 50000/' ${PHP_INI}
sed -i 's/session.gc_maxlifetime = 1440/session.gc_maxlifetime = 28800/' ${PHP_INI}
sed -i 's/mysql.allow_persistent = On/mysql.allow_persistent = Off/' ${PHP_INI}
sed -i 's/mysqli.allow_persistent = On/mysqli.allow_persistent = Off/' ${PHP_INI}
sed -i 's/pm = dynamic/pm = ondemand/' ${PHP_FPM_POOL}
sed -i 's/;pm.max_requests = 500/pm.max_requests = 10000/' ${PHP_FPM_POOL}
sed -i 's/^\(pm.max_children = \)[0-9]*/\1100/' ${PHP_FPM_POOL}

sed -i "s/\[www\]/\[${BRAND}\]/" ${PHP_FPM_POOL}
sed -i "s/^user =.*/user = ${PHP_USER}/" ${PHP_FPM_POOL}
sed -i "s/^group =.*/group = ${PHP_USER}/" ${PHP_FPM_POOL}
sed -ri "s/;?listen.owner =.*/listen.owner = ${PHP_USER}/" ${PHP_FPM_POOL}
sed -ri "s/;?listen.group =.*/listen.group = nginx/" ${PHP_FPM_POOL}
sed -ri "s/;?listen.mode = 0660/listen.mode = 0660/" ${PHP_FPM_POOL}
sed -ri "s/;?listen.allowed_clients =.*/listen.allowed_clients = $${_PRIVATE_IP}/" ${PHP_FPM_POOL}
sed -i '/sendmail_path/,$d' ${PHP_FPM_POOL}
sed -i '/PHPSESSID/d' ${PHP_INI}
sed -i "s,.*date.timezone.*,date.timezone = ${TIMEZONE}," ${PHP_INI}

cat >> ${PHP_FPM_POOL} <<END
;;
;; Custom pool settings
php_flag[display_errors] = off
php_admin_flag[log_errors] = on
php_admin_value[error_log] = "${WEB_ROOT_PATH}/var/log/php-fpm-error.log"
php_admin_value[default_charset] = UTF-8
php_admin_value[memory_limit] = 1048M
php_admin_value[date.timezone] = ${TIMEZONE}
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

## varnish configuration
uuidgen > /etc/varnish/secret

## nginx configuration
wget -qO /etc/nginx/fastcgi_params  $${_MAGENX_NGINX_REPO}magento2/fastcgi_params
wget -qO /etc/nginx/nginx.conf  $${_MAGENX_NGINX_REPO}magento2/nginx.conf
mkdir -p /etc/nginx/sites-enabled
mkdir -p /etc/nginx/sites-available && cd $_
curl -s $${_MAGENX_NGINX_REPO_API}/sites-available 2>&1 | awk -F'"' '/download_url/ {print $4 ; system("curl -sO "$4)}' >/dev/null
ln -s /etc/nginx/sites-available/magento2.conf /etc/nginx/sites-enabled/magento2.conf
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf
mkdir -p /etc/nginx/conf_m2 && cd /etc/nginx/conf_m2/
curl -s $${_MAGENX_NGINX_REPO_API}/conf_m2 2>&1 | awk -F'"' '/download_url/ {print $4 ; system("curl -sO "$4)}' >/dev/null

sed -i "s/example.com/${DOMAIN}/g" /etc/nginx/sites-available/magento2.conf
sed -i "s/example.com/${DOMAIN}/g" /etc/nginx/nginx.conf

sed -i "s/remote_addr/proxy_protocol_addr/" /etc/nginx/nginx.conf
sed -i "s/set_real_ip_from 127.0.0.1/set_real_ip_from ${VPC_CIDR}/" /etc/nginx/nginx.conf

sed -i '/set_real_ip_from/a\
real_ip_header proxy_protocol; \
' /etc/nginx/nginx.conf

sed -i "s/realip_remote_addr/proxy_protocol_addr/" /etc/nginx/conf_m2/varnish_proxy.conf
sed -i "s/proxy_add_x_forwarded_for/proxy_protocol_addr/" /etc/nginx/conf_m2/varnish_proxy.conf

sed -i "s,/var/www/html,${WEB_ROOT_PATH},g" /etc/nginx/conf_m2/maps.conf
 

