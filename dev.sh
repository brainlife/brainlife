#!/bin/bash

set -ex

###################################################################
#
# preflight checks
#
#check files that developers should provide
if [ ! -f warehouse/api/config/github.access_token ]; then
  echo "Please create warehouse/api/config.github.access_token from https://github.com/settings/tokens"
  exit 1
fi
if [ ! -f amaretti/config/github.access_token ]; then
  echo "Please create amaretti/config/github.access_token from https://github.com/settings/tokens"
  exit 1
fi

# install dev config
if [ ! -f auth/ui/config.js ]; then
  echo "installing dev config for auth/ui"
  cp auth/ui/config.js.dev auth/ui/config.js
fi

if [ ! -f auth/api/config/index.js ]; then
  echo "installing dev config for auth"
  cp auth/api/config/index.js.dev auth/api/config/index.js
fi

if [ ! -f event/api/config/index.js ]; then
  echo "installing dev config for event"
  cp event/api/config/index.js.dev event/api/config/index.js
fi

if [ ! -f amaretti/config/index.js ]; then
  echo "installing dev config for amaretti"
  cp amaretti/config/index.js.dev amaretti/config/index.js
fi

if [ ! -f warehouse/api/config/index.js ]; then
  echo "installing dev config for warehouse/api"
  cp warehouse/api/config/index.js.dev warehouse/api/config/index.js
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

if [ ! -d /tmp/.X11-unix ]; then
  echo "Can't find /tmp/.X11-unix - vis server needs X server (like Xquartz)." 
  exit
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
# now ready to start it up!
CMD=$@
if [ -z "$CMD" ];
then
    CMD="up";
fi

docker-compose $CMD
