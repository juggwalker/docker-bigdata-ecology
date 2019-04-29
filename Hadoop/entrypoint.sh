#!/bin/sh
set -eu

/usr/sbin/sshd -D


exec "$@"
