FROM ubuntu:18.04
MAINTAINER best "https://github.com/best7766"
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN echo exit 0 > /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

ENV TZ 'Europe/Tallinn'
    RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install vim && \
    apt-get -y install wget && \
    apt-get -y install git && \
    apt-get -y install tar && \
    apt-get -y install curl && \
    apt-get -y install nano && \
    apt-get -y install gzip && \
    apt-get -y install build-essential && \
    apt-get -y install openssh-server && \
    apt-get autoclean && \
    apt-get autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'root:root1234' |chpasswd

RUN sed -ri 's/^#?PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN mkdir /root/.ssh

# Docker config

RUN wget https://raw.githubusercontent.com/mediabots/ubuntu_-_lamp-kubuntu_desktop-wordpress-ssl/master/mediabots_ui.sh
RUN chmod +x /mediabots_ui.sh
RUN sudo sed -i 's/phpmyadmin_PASSWORD/php_1234/g' mediabots_ui.sh
RUN sudo sed -i 's/mysql_PASSWORD/mysql_1234/g' mediabots_ui.sh
EXPOSE 3389 22 80 443
# ENTRYPOINT ["/mediabots_ui.sh"] 
CMD    ["/usr/sbin/sshd", "-D"]
