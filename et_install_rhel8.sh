#!/bin/bash -xv

if [[ $UID -ne 0 ]]; then
    echo "Need to run as root !"
    exit 1
fi

dnf -y install https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/e/et-6.0.7-1.el8.x86_64.rpm https://dl.fedoraproject.org/pub/epel/8/Everything/x86_64/Packages/l/libsodium-1.0.18-2.el8.x86_64.rpm
systemctl enable --now et
systemctl disable --now firewalld

