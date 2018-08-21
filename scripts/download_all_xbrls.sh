#!/bin/sh

if [ $# -lt 3 ]; then
    echo "Usage: $0 <container_id> <sh|sz> <before_date>"
    exit 1
fi

container_id=$1
exchange_code=$2
before_date=$3

echo "download $exchange_code $before_date"

docker exec $container_id mix aimidas.import.download_all_xbrls $exchange_code $before_date