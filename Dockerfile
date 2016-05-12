FROM centos:6.7
MAINTAINER naelwan <naelwan@gmail.com>

# Update CentOS
RUN yum -y update

# Install wget
RUN yum install -y wget

# Get Centreon Repo
RUN wget http://yum.centreon.com/standard/3.0/stable/ces-standard.repo -O /etc/yum.repos.d/ces-standard.repo

# Install Packages (SSH, sudo, Centreon Poller & Engine)
RUN yum install -y --nogpgcheck openssh-clients openssh-server centreon-poller-centreon-engine sudo

#Start Services
RUN service centengine start
RUN service sshd start
RUN service snmpd start

#Change centreon user password
RUN echo -e "password" | (passwd --stdin centreon)
