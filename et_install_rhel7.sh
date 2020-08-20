
#!/bin/bash -xv

if [[ $UID -ne 0 ]]; then
    echo "Need to run as root !"
    exit 1
fi

yum -y install yum-utils yum-priorities
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum-config-manager --setopt="epel.priority=100" --save | grep -E '\[|priority'

yum -y install wget make kernel-devel rpm-build
grep -q CentOS /etc/redhat-release && \
yum -y install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
yum -y install devtoolset-7
yum -y upgrade

SRPM=https://copr-be.cloud.fedoraproject.org/results/masakifuruta/et/srpm-builds/01618165/et-6.0.11-2.fc32.src.rpm
wget -c ${SRPM}
rm -fv /root/rpmbuild/RPMS/x86_64/et-*.el7.x86_64.rpm
rpmbuild --rebuild ./${SRPM##*/} || \
    ( rpmbuild --rebuild ./${SRPM##*/} 2>&1 | sed -e '/needed/!d' -e 's/is.*//g' | perl -pe "s/\n/ /g" | xargs yum -y install; rpmbuild --rebuild ./${SRPM##*/} )
rpm -Uvh /root/rpmbuild/RPMS/x86_64/et-*.el7.x86_64.rpm
systemctl enable --now et
systemctl disable --now firewalld

 
