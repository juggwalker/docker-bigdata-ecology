#!/bin/sh
set -eu

systemctl start sshd.service

exec "$@"
