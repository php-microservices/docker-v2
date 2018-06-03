#!/bin/bash
set -e

help() {
    echo 'Make requests to the Nginx stub_status endpoint and pull out metrics'
    echo 'for the telemetry service. Refer to the Nginx docs for details:'
    echo 'http://nginx.org/en/docs/http/ngx_http_stub_status_module.html'
}

unhandled() {
    local accepts=$(curl -s --fail localhost/nginx-health | awk 'FNR == 3 {print $1}')
    local handled=$(curl -s --fail localhost/nginx-health | awk 'FNR == 3 {print $2}')
    echo $(expr ${accepts} - ${handled})
}

connections_load() {
    local scraped=$(curl -s --fail localhost/nginx-health)
    local active=$(echo ${scraped} | awk '/Active connections/{print $3}')
    local waiting=$(echo ${scraped} | awk '/Reading/{print $6}')
    local workers=$(echo $(cat /etc/nginx/nginx.conf | perl -n -e'/worker_connections *(\d+)/ && print $1')
)
    echo $(echo "scale=4; (${active} - ${waiting}) / ${workers}" | bc)
}

cmd=$1
if [ ! -z "$cmd" ]; then
    shift 1
    $cmd "$@"
    exit
fi

help
