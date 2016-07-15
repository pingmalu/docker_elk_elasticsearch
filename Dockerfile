FROM ubuntu:trusty
MAINTAINER MaLu <malu@malu.me> 

ADD sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y openssh-server pwgen vim lrzsz && \
    apt-get install -y nginx supervisor apache2-utils

RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config && sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config


# 用完包管理器后安排打扫卫生可以显著的减少镜像大小.
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV ELASTICSEARCH_USER **None**
ENV ELASTICSEARCH_PASS **None**

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD supervisord-sshd.conf /etc/supervisor/conf.d/supervisord-sshd.conf
ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD nginx_default /etc/nginx/sites-enabled/default
RUN chmod +x /*.sh

EXPOSE 9200 22 80 6379 443 21 23 8080 8888 8000 27017 3306
CMD ["/run.sh"]
