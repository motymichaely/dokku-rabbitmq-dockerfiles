#!/bin/bash

export DB_DIR="rabbitmq@docker"
export RABBITMQ_MNESIA_BASE=/opt/rabbitmq
export RABBITMQ_MNESIA_DIR="$RABBITMQ_MNESIA_BASE/$DB_DIR"
export RABBITMQ_LOGS="$RABBITMQ_MNESIA_BASE/$DB_DIR.log"
export RABBITMQ_SASL_LOGS="$RABBITMQ_MNESIA_BASE/$DB_DIR-sasl.log"
export RABBITMQ_PLUGINS_EXPAND_DIR="$RABBITMQ_MNESIA_BASE/$DB_DIR-plugins-expand"
export RABBITMQ_PID_FILE="$RABBITMQ_MNESIA_BASE/$DB_DIR.pid"

if [[ ! -f /opt/rabbitmq/initialized ]]; then
    mkdir -p /opt/rabbitmq
    cp -a /var/lib/rabbitmq/mnesia/* /opt/rabbitmq/
    touch /opt/rabbitmq/initialized
fi
chown -R rabbitmq:rabbitmq /opt/rabbitmq

if [[ ! -z "$1" ]]; then
    /usr/lib/rabbitmq/bin/rabbitmq-server -detached
    sleep 6
    # add new user
    /usr/lib/rabbitmq/bin/rabbitmqctl add_user admin $1
    /usr/lib/rabbitmq/bin/rabbitmqctl set_permissions -p / admin ".*" ".*" ".*"
    /usr/lib/rabbitmq/bin/rabbitmqctl set_user_tags admin administrator
    # remove default user
    /usr/lib/rabbitmq/bin/rabbitmqctl delete_user guest
    /usr/lib/rabbitmq/bin/rabbitmqctl stop
    sleep 4
fi

/usr/lib/rabbitmq/bin/rabbitmq-server
