#!/bin/bash

set -ex

###################################################################
#
# preflight checks
#
#check files that developers should provide
if [ ! -f warehouse/api/config/github.access_token ]; then
  echo "Please create warehouse/api/config.github.access_token from https://github.com/settings/tokens"
fi
if [ ! -f amaretti/config/github.access_token ]; then
  echo "Please create warehouse/api/config.github.access_token from https://github.com/settings/tokens"
fi

#setup volume directories that needs to be non-root
for path in archive stage secondary upload singularity compute
do
  if [ ! -d volumes/$path ]; then
    mkdir -p volumes/$path
    #sudo chown 1000:1000 volumes/$path
  fi
done

#make sure needed commands exists
hash docker
hash docker-compose

#sudo chown 1000:1000 archive/.ssh
#sudo chown 1000:1000 upload/.ssh

if [ ! -f /tmp/.X11-unix/X* ]; then
  echo "Can't find /tmp/.X11-unix/X* - vis server needs X server." 
fi

###################################################################
#
# install ui packages
#
for ui in $(ls ui); do
  if [ ! -d ui/$ui/node_modules ]; then
    (cd ui/$ui && npm install && npm update)
  fi
done

#build tractview dist
if [ ! -d ui/tractview/dist ]; then
  (cd ui/tractview && npm run build)
fi

###################################################################
#
# install all npm packages
#
#authentication service api
[ ! -d auth/node_modules ] && (cd auth && npm install)

#authentication service web ui
[ ! -d auth/ui/node_modules ] && (cd auth/ui && npm install)

#amaretti service api
[ ! -d amaretti/node_modules ] && (cd amaretti && npm install)

#event service
[ ! -d event/node_modules ] && (cd event && npm install)

#warehouse service api
[ ! -d warehouse/node_modules ] && (cd warehouse && npm install)

#warehouse web ui
[ ! -d warehouse/ui/node_modules ] && (cd warehouse/ui && npm install)

###################################################################
#
# generate files
#
(
  cd auth/api/config
  if [ ! -f auth.key ]; then
    echo "auth.key missing.. creating"
    openssl genrsa -out auth.key 2048
    chmod 600 auth.key
    openssl rsa -in auth.key -pubout > auth.pub
  fi
)

(
  cd event/api/config
  if [ ! -f event.jwt ]; then
    #TODO - I need to run this inside running auth api container so it can connect to the DB?
    ../../../auth/bin/auth.js issue --scopes '{ "sca": ["admin"] }' --sub 'event' > event.jwt
  fi
)
cp auth/api/config/auth.pub event/api/config/auth.pub

(
  cd amaretti/config
  if [ ! -f amaretti.jwt ]; then
    #TODO - I need to run this inside running auth api container so it can connect to the DB?
    ../../auth/bin/auth.js issue --scopes '{ "auth": ["admin"], "amaretti": ["admin"] }' --sub 'amaretti' > amaretti.jwt
  fi
)
cp auth/api/config/auth.pub amaretti/config/auth.pub

(
  cd warehouse/api/config
  if [ ! -f warehouse.jwt ]; then
    #TODO - I need to run this inside running auth api container so it can connect to the DB?
    ../../../auth/bin/auth.js issue --scopes '{ "auth": ["admin"], "amaretti": ["admin"], "profile": ["admin"] }' --sub 'warehouse' > warehouse.jwt
  fi

  if [ ! -f warehouse.key ]; then
    openssl genrsa -out warehouse.key 2048
    chmod 600 warehouse.key
    openssl rsa -in warehouse.key -pubout > warehouse.pub
  fi

  #for xnat?
  if [ ! -f configEncrypt.key ]; then
    openssl genrsa -out configEncrypt.key 2048
    chmod 600 configEncrypt.key
  fi
)
cp auth/api/config/auth.pub warehouse/api/config/auth.pub
cp warehouse/api/config/configEncrypt.key archive/.ssh

###################################################################
#
# now ready to start it up!
docker-compose up --build


