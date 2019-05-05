#!/bin/sh
set -eu

# cmd.sh

$ZOOKEEPER_HOME/bin/zkServer.sh start

# 该容器永远不会退出
tail -f /dev/null