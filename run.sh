#!/bin/bash
if [ "${AUTHORIZED_KEYS}" != "**None**" ]; then
    echo "=> Found authorized keys"
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
    IFS=$'\n'
    arr=$(echo ${AUTHORIZED_KEYS} | tr "," "\n")
    for x in $arr
    do
        x=$(echo $x |sed -e 's/^ *//' -e 's/ *$//')
        cat /root/.ssh/authorized_keys | grep "$x" >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "=> Adding public key to /root/.ssh/authorized_keys: $x"
            echo "$x" >> /root/.ssh/authorized_keys
        fi
    done
fi

if [ ! -f /.root_pw_set ]; then
    /set_root_pw.sh
fi

set -e

if [ "${ELASTICSEARCH_USER}" == "**None**" ] && [ "${ELASTICSEARCH_PASS}" == "**None**" ]; then
    echo "=> Starting Elasticsearch with no base auth ..."
    echo "========================================================================"
    echo "You can now connect to this Elasticsearch Server using:"
    echo ""
    echo "    curl localhost:9200"
    echo ""
    echo "========================================================================"
    exec /usr/share/elasticsearch/bin/elasticsearch -Des.http.port=9200
else
    USER=${ELASTICSEARCH_USER:-admin}
    echo "=> Starting Elasticsearch with basic auth ..."
    echo ${ELASTICSEARCH_PASS} | htpasswd -i -c /htpasswd ${USER}
    echo "========================================================================"
    echo "You can now connect to this Elasticsearch Server using:"
    echo ""
    echo "    curl ${USER}:${ELASTICSEARCH_PASS}@localhost:9200"
    echo ""
    echo "========================================================================"
fi

exec /usr/bin/supervisord -n
