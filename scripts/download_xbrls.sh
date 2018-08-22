#!/bin/sh

if [ $# -lt 3 ]; then
    echo "Usage: $0 <container_id> <sh|sz> <company_code>"
    exit 1
fi

container_id=$1
exchange_code=$2
company_code=$3

echo "download $exchange_code $company_code"

docker exec $container_id mix aimidas.import.download_xbrls $exchange_code $company_code