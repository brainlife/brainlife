#!/bin/bash

set -e

docker-compose exec mongodb \
  bash -c "mongo <<EOF
const mongo = db.getMongo();
mongo.getDBNames().forEach(function (db) {
  if (db == 'admin' || db == 'local' || db == 'config') {
    return;
  }
  mongo.getDB(db).dropDatabase();
});
EOF"
