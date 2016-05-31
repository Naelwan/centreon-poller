FROM centos:6.7
MAINTAINER naelwan <naelwan@gmail.com>

# Update CentOS
RUN yum -y update ; yum clean all

# Install wget
RUN yum install -y wget ; yum clean all

# Get Centreon Repo
RUN wget http://yum.centreon.com/standard/3.0/stable/ces-standard.repo -O /etc/yum.repos.d/ces-standard.repo

# Install Packages (SSH, sudo, Centreon Poller & Engine, SNMP)
RUN yum install -y --nogpgcheck openssh-clients openssh-server centreon-poller-centreon-engine sudo net-snmp net-snmp-utils


ADD services.sh /etc/
RUN chmod +x /etc/services.sh


# Change centreon user password
RUN echo "centreon:password" | chpasswd
RUN echo "root:password" | chpasswd


# Disable PAM (causing issues while ssh login)
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Start services
CMD ["/etc/services.sh"]
