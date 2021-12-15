#!/bin/bash

packages='''
python-samba
samba
samba-common
samba-dsdb-modules
samba-libs
samba-vfs-modules
'''

for i in $packages; do
	sudo apt-mark unhold $i
done

