#!/bin/sh
set -eu

/usr/sbin/init
#/usr/sbin/sshd -D

systemctl start sshd.service

exec "$@"
