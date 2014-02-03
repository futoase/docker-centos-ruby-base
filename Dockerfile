FROM centos

MAINTAINER Keiji Matsuzaki <futoase@gmail.com>

# setup network
# reference from https://github.com/dotcloud/docker/issues/1240#issuecomment-21807183
RUN echo "NETWORKING=yes" > /etc/sysconfig/network

# setup remi repository
RUN wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
RUN curl -O http://rpms.famillecollet.com/RPM-GPG-KEY-remi; rpm --import RPM-GPG-KEY-remi
RUN rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm

RUN yum -y update
RUN yum -y groupinstall --enablerepo=epel,remi "Development Tools"
RUN yum -y install --enablerepo=epel,remi openssl-devel git sqlite sqlite-devel libyaml-devel libxslt-devel

# setup ruby-install
RUN mkdir -p /tmp/download
RUN wget -O /tmp/download/ruby-install-0.3.4.tar.gz https://github.com/postmodern/ruby-install/archive/v0.3.4.tar.gz
RUN cd /tmp/download && tar -xvzf ruby-install-0.3.4.tar.gz
RUN cd /tmp/download/ruby-install-0.3.4 && make install

RUN ruby-install ruby 2.0.0-p353

ENV PATH /opt/rubies/ruby-2.0.0-p353/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN gem install bundle --no-ri --no-rdoc 
