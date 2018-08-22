#!/bin/sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 <container_id> <infos_path>"
    exit 1
fi

container_id=$1
infos_path=$2

echo "infos_path path: $infos_path"

if [ ! -f "$infos_path" ];then
  echo "Error: path $infos_path doesn't exist"
  exit 2
fi

#docker exec $container_id rm -rf /xbrls
docker cp $infos_path $container_id:/company_infos.json
docker exec $container_id mix aimidas.import.company_infos /company_infos.json