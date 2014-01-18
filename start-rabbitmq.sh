#!/bin/bash

if [[ ! -f /opt/rabbitmq/initialized ]]; then
    mkdir -p /opt/rabbitmq
    cp -a /var/lib/rabbitmq/mnesia/* /opt/rabbitmq/
    chown -R rabbitmq:rabbitmq /opt/rabbitmq
    touch /opt/rabbitmq/initialized
fi

export RABBITMQ_MNESIA_BASE=/opt/rabbitmq
/usr/sbin/rabbitmq-server -detached
sleep 2
# remove default user
rabbitmqctl delete_user guest
# add new user
rabbitmqctl add_user admin $1
rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
rabbitmqctl set_user_tags admin administrator
rabbitmqctl stop
sleep 2
/usr/sbin/rabbitmq-server