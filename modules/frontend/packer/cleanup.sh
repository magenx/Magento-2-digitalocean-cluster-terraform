#!/bin/bash

apt-get -y autoremove
apt-get -y autoclean
apt-get -y clean

rm -rf /tmp/* /var/tmp/*

history -c
cat /dev/null > /root/.bash_history
unset HISTFILE

dd if=/dev/zero of=/zerofile bs=4096 || rm /zerofile
