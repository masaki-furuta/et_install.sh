#!/bin/bash -xv

if [[ $UID -ne 0 ]]; then
    echo "Need to run as root !"
    exit 1
fi

yum -y install yum-utils yum-priorities
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum-config-manager --setopt="epel.priority=100" --save | grep -E '\[|priority'

#yum -y install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
yum -y install devtoolset-7
#scl enable devtoolset-7 bash
source /opt/rh/devtoolset-7/enable
yum -y upgrade

yum -y install wget make kernel-devel
wget -c https://dl.fedoraproject.org/pub/epel/8/Everything/SRPMS/Packages/e/et-6.0.7-1.el8.src.rpm
rpmbuild --rebuild ./et-6.0.7-1.el8.src.rpm || \
    ( rpmbuild --rebuild ./et-6.0.7-1.el8.src.rpm 2>&1 | grep needed | sed -e 's/is.*//g' | perl -pe "s/\n/ /g" | xargs yum -y install; rpmbuild --rebuild ./et-6.0.7-1.el8.src.rpm )
rpm -ivh /root/rpmbuild/RPMS/x86_64/et-*.el7.x86_64.rpm
systemctl enable --now et

