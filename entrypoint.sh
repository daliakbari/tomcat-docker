#!/bin/bash
set -e

# preferable to fire up Tomcat via start-tomcat.sh which will start Tomcat with
# security manager, but inheriting containers can also start Tomcat via
# catalina.sh

if [ "$1" = 'start-tomcat.sh' ] || [ "$1" = 'catalina.sh' ]; then

    USER_ID=${TOMCAT_USER_ID:-1000770000}
    GROUP_ID=${TOMCAT_GROUP_ID:-1000770000}

    ###
    # Tomcat user
    ###
    groupadd -r modirsan -g ${GROUP_ID} && \
    useradd -u ${USER_ID} -g modirsan -d ${CATALINA_HOME} -s /sbin/nologin \
        -c "Tomcat user" modirsan

    ###
    # Change CATALINA_HOME ownership to tomcat user and tomcat group
    # Restrict permissions on conf
    ###

    chown -R modirsan:modirsan ${CATALINA_HOME} && chmod 400 ${CATALINA_HOME}/conf/*
    sync
    exec gosu modirsan "$@"
fi

exec "$@"
