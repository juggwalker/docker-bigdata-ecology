#!/bin/sh
set -eu

is_empty_dir(){
    return `ls -A $1|wc -w`
}

if [ ! -d $HADOOP_NAMENODE_DIR ] || is_empty_dir $HADOOP_NAMENODE_DIR; then
    $HADOOP_HOME/bin/hdfs namenode -format
fi

/usr/sbin/sshd -D &

exec "$@"
