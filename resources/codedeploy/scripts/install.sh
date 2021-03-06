#!/bin/bash
cd /srv/project

while [ ! -f /usr/local/etc/subsite/subsite.ini ]
do
  sleep 2
done

vendor/bin/phing -propertyfile /usr/local/etc/subsite/subsite.ini install setup-acceptance  >> /var/log/subsite-install.log 2>&1
chown -R www-data:www-data /srv/project
