#!/bin/bash

# Script is used to uninstall samba on server.

sudo apt -y remove --purge samba samba-common cifs-utils smbclient libwbclient0
sudo rm -rf /var/cache/samba /etc/samba /run/samba /var/lib/samba /var/log/samba
sudo apt -y remove --purge python-samba samba-dsdb-modules samba-libs:amd64
apt-get -y autoremove
