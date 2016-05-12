FROM centos:6.7
MAINTAINER naelwan <naelwan@gmail.com>

# Update CentOS
RUN yum -y update

# Install wget
RUN yum install -y wget

# Get Centreon Repo
RUN wget http://yum.centreon.com/standard/3.0/stable/ces-standard.repo -O /etc/yum.repos.d/ces-standard.repo

# Install Packages (SSH, sudo, Centreon Poller & Engine)
RUN yum install -y --nogpgcheck openssh-clients openssh-server centreon-poller-centreon-engine sudo supervisor


COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf


#Change centreon user password
RUN echo -e "password" | (passwd --stdin centreon)

EXPOSE 22 5669
CMD ["/usr/bin/supervisord"]
