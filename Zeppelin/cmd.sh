#!/bin/sh
set -eu

# cmd.sh


$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start

# 该容器永远不会退出
tail -f /dev/null