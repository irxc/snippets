#!/bin/bash
# cleaning up domain-info from lab-machine
# Run as sudo
if (( $EUID != 0 )); then
    echo "Please run as root or sudo, script will now exit."
    exit
fi
rm -rf /var/db/dslocal/nodes/Default/config/
rm -rf /etc/krb5.keytab
rm -rf /Library/Preferences/OpenDirectory
rm -rdfv /Library/Preferences/DirectoryService
rm -rdfv /var/db/dslocal/nodes/Default/config
killall -USR1 DirectoryService
killall -USR1 opendirectoryd
echo Cleaning done, you should probably reboot.. 


