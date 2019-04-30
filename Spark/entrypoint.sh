#!/bin/sh
set -eu

is_empty_dir(){
    return `ls -A $1|wc -w`
}

/usr/sbin/sshd -D &

exec "$@"
