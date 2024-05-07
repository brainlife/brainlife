#!/bin/sh

set -e

AUTH="node /app/dist/cli.js"

USERNAME=$1

echo -n "Password for $USERNAME: "
read -s PASSWORD

$AUTH setpass --username $USERNAME --password $PASSWORD
