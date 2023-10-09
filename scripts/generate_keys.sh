#!/bin/bash

set -ex

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

# Auth
if [ ! -f auth/api/config/auth.key ]; then
  openssl genrsa -out auth/api/config/auth.key 2048
  chmod 600 auth/api/config/auth.key
  openssl rsa -in auth/api/config/auth.key -pubout > auth/api/config/auth.pub
fi

# Events
if [ ! -f event/api/config/event.jwt ]; then
  $AUTH issue --scopes '{ "sca": ["admin"] }' --sub 'event' > event/api/config/event.jwt
fi
cp auth/api/config/auth.pub event/api/config/auth.pub

# Amaretti
if [ ! -f amaretti/config/amaretti.jwt ]; then
  $AUTH issue --scopes '{ "auth": ["admin"], "amaretti": ["admin"] }' --sub 'amaretti' > amaretti/config/amaretti.jwt
fi
cp auth/api/config/auth.pub amaretti/config/auth.pub

# Warehouse
if [ ! -f warehouse/api/config/warehouse.jwt ]; then
  $AUTH issue --scopes '{ "auth": ["admin"], "amaretti": ["admin"], "profile": ["admin"] }' --sub 'warehouse' > warehouse/api/config/warehouse.jwt
fi
if [ ! -f warehouse/api/config/warehouse.key ]; then
  openssl genrsa -out warehouse/api/config/warehouse.key 2048
  chmod 600 warehouse/api/config/warehouse.key
  openssl rsa -in warehouse/api/config/warehouse.key -pubout > warehouse/api/config/warehouse.pub
fi
if [ ! -f warehouse/api/config/configEncrypt.key ]; then
  openssl genrsa -out warehouse/api/config/configEncrypt.key 2048
  chmod 600 warehouse/api/config/configEncrypt.key
fi
cp auth/api/config/auth.pub warehouse/api/config/auth.pub


# EZBIDS
cp auth/api/config/auth.pub ezbids/api/auth.pub

# Archive
mkdir -p archive/.ssh
cp warehouse/api/config/configEncrypt.key archive/.ssh/configEncrypt.key
