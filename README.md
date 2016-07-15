# docker_elk_elasticsearch 5.0.0-alpha4

    - docker run -d -p 9222:9200 -e ELASTICSEARCH_USER=admin -e ELASTICSEARCH_PASS=mypass elasticsearch; sleep 30
    - curl -L -I admin:mypass@127.0.0.1:9222 | grep "200 OK"
