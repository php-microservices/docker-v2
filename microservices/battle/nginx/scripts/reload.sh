#!/bin/bash

SERVICE_NAME=${SERVICE_NAME:-nginx}
CONSUL=${CONSUL:-consul}

preStart() {
    consul-template \
        -once \
        -dedup \
        -consul ${CONSUL}:8500 \
        -template "/etc/nginx/nginx.conf.ctmpl:/etc/nginx/nginx.conf"
}

onChange() {
    consul-template \
        -once \
        -dedup \
        -consul ${CONSUL}:8500 \
        -template "/etc/nginx/nginx.conf.ctmpl:/etc/nginx/nginx.conf:nginx -s reload"
}

help() {
    echo "Usage: ./reload.sh preStart  => first-run configuration for Nginx"
    echo "       ./reload.sh onChange  => [default] update Nginx config on upstream changes"
}

until
    cmd=$1
    if [ -z "$cmd" ]; then
        onChange
    fi
    shift 1
    $cmd "$@"
    [ "$?" -ne 127 ]
do
    onChange
    exit
done
