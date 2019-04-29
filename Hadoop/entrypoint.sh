#!/bin/sh
set -eu

/usr/sbin/init
#/usr/sbin/sshd -D

systemctl restart sshd.service

exec "$@"
