FROM centos:6.7
MAINTAINER naelwan <naelwan@gmail.com>

# Update CentOS
RUN yum -y update

# Install wget
RUN yum install -y wget

# Get Centreon Repo
RUN wget http://yum.centreon.com/standard/3.0/stable/ces-standard.repo -O /etc/yum.repos.d/ces-standard.repo

# Install Packages (SSH, sudo, Centreon Poller & Engine, SNMP)
RUN yum install -y --nogpgcheck openssh-clients openssh-server centreon-poller-centreon-engine sudo net-snmp net-snmp-utils

# Install supervisord
RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN yum --enablerepo=epel install -y supervisor
RUN mv -f /etc/supervisord.conf /etc/supervisord.conf.org
ADD supervisord.conf /etc/


# Change centreon user password
RUN echo -e "password" | (passwd --stdin centreon)

# Disable PAM (causing issues while ssh login)
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Start supervisord
CMD ["/usr/bin/supervisord"]
