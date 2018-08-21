#!/bin/sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 <container_id> <terms_path>"
    exit 1
fi

container_id=$1
terms_path=$2

echo "terms path: $terms_path"

if [ ! -f "$terms_path" ];then
  echo "Error: path $terms_path doesn't exist"
  exit 2
fi

#docker exec $container_id rm -rf /xbrls
docker cp $terms_path $container_id:/terms.json
docker exec $container_id mix aimidas.import.terms /terms.json