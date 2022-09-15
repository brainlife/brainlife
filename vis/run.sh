#!/bin/bash

set -ex

#chown -R root:root /root/.ssh

echo "#ENV from docker-compose.yaml"  > /root/.env
echo "export BRAINLIFE_HOSTSCRATCH=$BRAINLIFE_HOSTSCRATCH" >> /root/.env

/usr/sbin/sshd -D

#/usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock &
#/usr/bin/dockerd --containerd=/run/containerd/containerd.sock &
#/usr/bin/dockerd
