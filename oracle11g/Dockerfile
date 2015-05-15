FROM centos:centos6

# Oracle user
RUN useradd -d /home/oracle -m -s /bin/bash oracle
ADD files/bashrc /home/oracle/.bashrc
RUN chown oracle:oracle /home/oracle/.bashrc

# Dependencies
RUN yum -y install wget
RUN wget --no-check-certificate -O/etc/yum.repos.d/public-yum-ol6.repo https://public-yum.oracle.com/public-yum-ol6.repo
RUN wget --no-check-certificate -O/etc/pki/rpm-gpg/RPM-GPG-KEY-oracle https://public-yum.oracle.com/RPM-GPG-KEY-oracle-ol6
RUN yum -y install oracle-rdbms-server-11gR2-preinstall
RUN yum -y install binutils compat-libstdc++-33 compat-libstdc++-33.i686 ksh elfutils-libelf elfutils-libelf-devel glibc glibc-common glibc-devel gcc gcc-c++ libaio libaio.i686 libaio-devel libaio-devel.i686 libgcc libstdc++ libstdc++.i686 libstdc++-devel libstdc++-devel.i686 make sysstat unixODBC unixODBC-devel unzip xorg-x11-server-Xvfb

# Setup
RUN echo "* - nproc unlimited" >> /etc/security/limits.d/90-nproc.conf
RUN sed -i -e 's/HOSTNAME=.*/HOSTNAME=oracle11g/' /etc/sysconfig/network
RUN mkdir /opt/oracle && chown oracle:oracle /opt/oracle
RUN mkdir /opt/oraInventory && chown oracle:oracle /opt/oraInventory
ADD files/setenv.sh /root/setenv.sh
ADD files/install.sh /root/install.sh
ADD files/start.sh /start.sh

