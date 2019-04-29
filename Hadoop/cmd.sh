#!/bin/sh
set -eu

# cmd.sh

# /usr/local/hadoop/hadoop-3.2.0/sbin/start-all.sh
$HADOOP_HOME/sbin/start-all.sh

# 该容器永远不会退出
tail -f /dev/null