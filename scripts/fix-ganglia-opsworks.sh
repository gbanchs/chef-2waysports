#!/bin/bash
#Fix broken ganglia opsworks recipe
#Requires root

mkdir -p /var/lib/ganglia/dwoo/{compiled,cache}
chown -R www-data.www-data /var/lib/ganglia/dwoo
