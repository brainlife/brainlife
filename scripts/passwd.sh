#!/bin/bash

set -e

if [[ "$@" == *--wipe* ]]; then
  rm -f auth/api/config/auth.key
  rm -f auth/api/config/auth.pub
  rm -f event/api/config/auth.pub
  rm -f event/api/config/event.jwt
  rm -f amaretti/config/amaretti.jwt
  rm -f amaretti/config/auth.pub
  rm -f warehouse/api/config/auth.pub
  rm -f warehouse/api/config/configEncrypt.key
  rm -f warehouse/api/config/warehouse.jwt
  rm -f warehouse/api/config/warehouse.key
  rm -f warehouse/api/config/warehouse.pub
  rm -f archive/.ssh/configEncrypt.key
  exit 0
fi

AUTH="/app/bin/auth.js"
if [ ! -f $AUTH ]; then  # Not on docker-compose
  AUTH=$(realpath ./auth/bin/auth.js)
fi

USERNAME=$1

echo -n "Password for $USERNAME: "
read -s PASSWORD

docker-compose exec auth-api /app/bin/auth.js \
  setpass --username $USERNAME --password $PASSWORD
