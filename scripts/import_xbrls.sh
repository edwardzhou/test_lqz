#!/bin/sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 <container_id> <xbrls_path>"
    exit 1
fi

container_id=$1
xbrls_path=$2

echo "xbrls path: $xbrls_path"

if [ ! -d "$xbrls_path" ];then
  echo "Error: path $xbrls_path doesn't exist"
  exit 2
fi

docker exec $container_id rm -rf /xbrls
docker cp $xbrls_path $container_id:/xbrls
docker exec $container_id mix aimidas.import.company_xbrls /xbrls