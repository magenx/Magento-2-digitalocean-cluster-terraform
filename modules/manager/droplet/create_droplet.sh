#!/bin/bash

_NEW_DROPLET_TAG="php-backend"

_CREATE_NEW_DROPLET () {
_NEW_DROPLET_DATA=$(doctl compute droplet create $${_NEW_DROPLET_TAG}-$${RANDOM}-${PROJECT} \
 --size ${SIZE} \
 --image ${IMAGE} \
 --region ${REGION} \
 --tag-names $${_NEW_DROPLET_TAG},loadbalancer \
 --vpc-uuid ${VPC_UUID} \
 --user-data ${USER_DATA} \
 --ssh_keys ${SSH_KEYS} \
 --no-header \
 --format=ID,PublicIPv4,PrivateIPv4 \
 --wait)
 }

## wait for connection first | if timeout then scale out
timeout 10 sh -c 'until nc -z $0 $1; do sleep 1; done' ${FRONTEND_IP} 80
if [ $? -eq 124 ] ; then
# Create droplet now
 _TIME_BEFORE_API="$(date -R)"
 
 _CREATE_NEW_DROPLET
 
else

## connection ok | check frontend droplet load average 
# Get CPU qty from frontend droplet 
_FRONTEND_DROPLET_CPU=$(ssh manager@${FRONTEND_IP} "nproc")
# Calculate droplet average load 5min
_FRONTEND_DROPLET_LOAD_5=$(ssh manager@${FRONTEND_IP} "cat /proc/loadavg | awk '{print $1}'")
_FRONTEND_DROPLET_LOAD_AVERAGE_5=$(ssh manager@${FRONTEND_IP} "($(echo $${_FRONTEND_DROPLET_LOAD_5} | awk '{print 100 * $1}') / $${_FRONTEND_DROPLET_CPU})")

# If droplet average 5min load >% then create new droplet
if [ $${_FRONTEND_DROPLET_LOAD_AVERAGE_5} -ge 80 ] ; then
# Get extra droplets total qty
_DROPLETS_TOTAL_QTY=$(doctl compute droplet list --tag-name $${_NEW_DROPLET_TAG} --format PrivateIPv4 --no-header | wc -l)

if [ $${_DROPLETS_TOTAL_QTY} -le 5 ] ; then

_TIME_BEFORE_API="$(date -R)"

_CREATE_NEW_DROPLET

fi

# If droplet was not created then exit with alert
if [ -z "$${_NEW_DROPLET_DATA}" ]; then
    mail -s "[!] Error while creating a new droplet at $(hostname)" -r "Droplet Error<${ALERT_EMAIL}>" ${ALERT_EMAIL}
    exit 1
fi

_TIME_AFTER_API="$(date -R)"

## set droplet private ip
_NEW_DROPLET_PRIVATE_IP=$${_NEW_DROPLET_DATA##* }

## wait for ssh connection to new droplet
timeout 60 sh -c 'until nc -z $0 $1; do sleep 1; done' $${_NEW_DROPLET_PRIVATE_IP} ${SSH_PORT} &> /dev/null && _TIME_SSH_CONTACT="$(date -R)" || exit 1

## wait for connection to nginx
timeout 60 sh -c 'until nc -z $0 $1; do sleep 1; done' $${_NEW_DROPLET_PRIVATE_IP} 80 &> /dev/null && _TIME_NGINX_CONTACT="$(date -R)" || exit 1

_TIME_DROPLET_READY="$(date -R)"

## check new droplet uptime status
_NEW_DROPLET_UPTIME=$(ssh manager@$${_NEW_DROPLET_PRIVATE_IP} "uptime -s;uptime -p")

## generate report log
cat > /tmp/droplet_create_report.txt <<END
Master droplet status: $(ssh manager@${FRONTEND_IP} "$(uptime)")
New droplet created: $${_NEW_DROPLET_DATA} - "$${_NEW_DROPLET_UPTIME}"
Command to create droplet sent: $${_TIME_BEFORE_API}
IP address registration:        $${_TIME_AFTER_API}
Droplet ssh connection ready:   $${_TIME_SSH_CONTACT}
Nginx session established:      $${_TIME_NGINX_CONTACT}
Droplet is ready for work:      $${_TIME_DROPLET_READY}
Report sent: $(date -R)
END

## send email when droplet created
cat /tmp/droplet_create_report.txt | mail -s "[+][INFO]: New droplet created at $(hostname)" -r "Droplet Created<${ALERT_EMAIL}>" ${ALERT_EMAIL}

