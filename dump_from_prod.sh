#!/bin/bash

#dump collections
ssh db1 docker exec -t mongo_warehouse mongodump --db=warehouse --port 27117 --collection=uis 
ssh db1 docker exec -t mongo_warehouse mongodump --db=warehouse --port 27117 --collection=datatypes
ssh db1 docker exec -t mongo_warehouse mongodump --db=warehouse --port 27117 --collection=apps

#take it out of container
ssh db1 rm -rf /tmp/dump #needed to prevent dump nesting inside /tmp/dump..
ssh db1 docker cp mongo_warehouse:dump /tmp/dump

#copy over here
rsync -av db1:/tmp/dump/ dbdump

