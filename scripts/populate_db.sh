#!/bin/bash

set -ex

# Run this script to populate initial set of data needed to run dev instance of brainlife.io

# Create test users & groups
docker exec -i brainlife_mongodb mongo "mongodb://localhost:27017/auth" < ./fixtures/users.js

# Create resources
docker exec -i brainlife_mongodb mongo "mongodb://localhost:27017/amaretti" < ./fixtures/resources.js

# Loading content from db dump (need content in dbdump)
docker exec brainlife_mongodb rm -rf /tmp/dump
docker cp dbdump brainlife_mongodb:/tmp/dump
docker exec brainlife_mongodb mongorestore /tmp/dump
