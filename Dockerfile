FROM ubuntu:trusty
MAINTAINER MaLu <malu@malu.me> 

ADD sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y wget nginx supervisor apache2-utils

# 安装java环境
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz && \
    tar -zxvf jdk-8u92-linux-x64.tar.gz && \
    mkdir -p /usr/local/java && \
    mv jdk1.8.0_92 /usr/local/java/

# 安装elasticsearch5
RUN wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/deb/elasticsearch/5.0.0-alpha4/elasticsearch-5.0.0-alpha4.deb && \
    dpkg -i elasticsearch-5.0.0-alpha4.deb && \
    mkdir -p /usr/share/elasticsearch/config && \
    cp /etc/elasticsearch/elasticsearch.yml /usr/share/elasticsearch/config/elasticsearch.yml && \
    sed -i '/^# http\.port/a http\.port:\ 9201' /usr/share/elasticsearch/config/elasticsearch.yml

RUN useradd -r -m -s /bin/bash malu && \
    mkdir /usr/share/elasticsearch/config/scripts && \
    mkdir /usr/share/elasticsearch/logs && \
    mkdir /usr/share/elasticsearch/data && \
    chown malu -R /usr/share/elasticsearch/

# 用完包管理器后安排打扫卫生可以显著的减少镜像大小.
RUN apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


ENV ELASTICSEARCH_USER **None**
ENV ELASTICSEARCH_PASS **None**

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD run.sh /run.sh
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
ADD nginx_default /etc/nginx/sites-enabled/default
RUN chmod +x /*.sh

EXPOSE 9200 22 80 6379 443 21 23 8080 8888 8000 27017 3306
CMD ["/run.sh"]
