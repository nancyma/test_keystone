FROM ubuntu:14.04
MAINTAINER nancy "mawenhua1978@163.com"

# install packages
RUN set -x
RUN apt-get -y update
RUN apt-get -y install software-properties-common
RUN add-apt-repository cloud-archive:liberty
RUN apt-get -y update
RUN apt-get -y dist-upgrade
RUN apt-get -y install python-openstackclient mysql-client
RUN apt-get -y update
RUN apt-get -y install mariadb-server python-mysqldb keystone \
		apache2 libapache2-mod-wsgi memcached python-memcache
RUN apt-get -y clean
RUN rm -f /var/lib/keystone/keystone.db

#copy configurations and scripts
COPY conf/keystone.override /etc/init/keystone.override
COPY conf/keystone.conf /etc/keystone/keystone.conf
COPY conf/apache2.conf /etc/apache2/apache2.conf
COPY conf/wsgi-keystone.conf /etc/apache2/sites-available/wsgi-keystone.conf
COPY conf/keystone-paste.ini /etc/keystone/keystone-paste.ini
COPY keystone.sql /root/keystone.sql
COPY shell/bootstrap.sh /etc/bootstrap.sh
COPY shell/admin-openrc.sh /root/admin-openrc.sh
COPY shell/demo-openrc.sh /root/demo-openrc.sh

RUN chown root:root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh
RUN chown root:root /root/*-openrc.sh && chmod a+x /root/*-openrc.sh

VOLUME /etc/keystone
EXPOSE 5000 35357 	

ENTRYPOINT ["/etc/bootstrap.sh"] 
