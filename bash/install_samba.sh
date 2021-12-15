#!/bin/bash
  
main_url='https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/21403429/+files/'

packageNames='''
samba-common_4.7.6+dfsg~ubuntu-0ubuntu2.23_all.deb
libwbclient0_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
libwbclient-dev_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
samba-libs_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
python-samba_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
samba-common-bin_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
samba_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
libsmbclient_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
smbclient_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
samba-vfs-modules_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
samba-dsdb-modules_4.7.6+dfsg~ubuntu-0ubuntu2.23_amd64.deb
'''

for i in $packageNames; do
        joined_url=$main_url$i
        echo $joined_url
        wget $joined_url
        if ! sudo apt -y install ./$i
        then
                echo "Failed to install $i"
        else
                echo "$i installed successfully."
                rm -rf $i
        fi
done
