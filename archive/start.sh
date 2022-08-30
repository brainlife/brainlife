#!/bin/bash

#will spawn without --forground. 
#use --debug for debug
automount

#will foreground
/usr/sbin/sshd -D
