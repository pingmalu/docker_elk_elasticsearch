# docker_elk_elasticsearch

控制内存：

	ENV ES_HEAP_SIZE 64m

supervisord开关：

	ENV SOPEN **None**

运行：

    - docker run -d -p 9222:9200 -e ELASTICSEARCH_USER=admin -e ELASTICSEARCH_PASS=mypass elasticsearch; sleep 30
    - curl -L -I admin:mypass@127.0.0.1:9222 | grep "200 OK"
