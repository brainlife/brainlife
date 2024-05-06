#!/bin/sh

set -ex

THIS=$(readlink -f "$0")
THISDIR=$(dirname "$THIS")

cd $THISDIR/..

WIPE=false
for i in "$@"; do
  case $i in
    --wipe)
      WIPE=true
      shift
      ;;
    -*|--*)
      echo "Unknown option $i"
      exit 1
      ;;
    *)
      ;;
  esac
done

if $WIPE; then
  rm -f auth/auth.key
  rm -f auth/auth.pub
  rm -f event/api/config/auth.pub
  rm -f event/api/config/event.jwt
  rm -f amaretti/config/amaretti.jwt
  rm -f amaretti/config/auth.pub
  rm -f warehouse/api/config/auth.pub
  rm -f warehouse/api/config/configEncrypt.key
  rm -f warehouse/api/config/warehouse.jwt
  rm -f warehouse/api/config/warehouse.key
  rm -f warehouse/api/config/warehouse.pub
  rm -f ezbids/api/auth.pub
  rm -f ezbids/api/ezbids.pub
  rm -f archive/.ssh/configEncrypt.key
  exit 0
fi

AUTH="node /app/dist/cli.js"

# Auth
if [ ! -f auth/auth.key ]; then
  openssl genrsa -out auth/auth.key 2048
  chmod 600 auth/auth.key
  openssl rsa -in auth/auth.key -pubout > auth/auth.pub
fi

# Events
if [ ! -f event/api/config/event.jwt ]; then
  $AUTH issue --scopes '{ "sca": ["admin"] }' --sub 'event' > event/api/config/event.jwt
fi
cp auth/auth.pub event/api/config/auth.pub

# Amaretti
if [ ! -f amaretti/config/amaretti.jwt ]; then
  $AUTH issue --scopes '{ "auth": ["admin"], "amaretti": ["admin"], "profile": ["admin"] }' --sub 'amaretti' > amaretti/config/amaretti.jwt
fi
cp auth/auth.pub amaretti/config/auth.pub

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
cp auth/auth.pub warehouse/api/config/auth.pub

# ezBIDS
if [ ! -f ezbids/api/auth.key ]; then
  openssl genrsa -out ezbids/api/ezbids.key 2048
  chmod 600 ezbids/api/ezbids.key
  openssl rsa -in ezbids/api/ezbids.key -pubout > ezbids/api/ezbids.pub
fi
cp auth/auth.pub ezbids/api/auth.pub

# Archive
mkdir -p archive/.ssh
cp warehouse/api/config/configEncrypt.key archive/.ssh/configEncrypt.key
