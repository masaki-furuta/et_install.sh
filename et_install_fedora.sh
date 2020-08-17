#!/bin/bash -xv

if [[ $UID -ne 0 ]]; then
    echo "Need to run as root !"
    exit 1
fi

dnf -y install et
systemctl enable --now et
systemctl disable --now firewalld

