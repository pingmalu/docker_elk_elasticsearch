FROM tutum/curl:trusty
MAINTAINER Malu <malu@malu.me>

RUN curl http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add - && \
    echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y supervisor elasticsearch openjdk-7-jre-headless && \
    /usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENV SOPEN **None**

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD run.sh /run.sh
RUN chmod +x /*.sh

EXPOSE 9200
CMD ["/run.sh"]
