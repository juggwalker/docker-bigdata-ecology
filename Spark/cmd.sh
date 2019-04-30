#!/bin/sh
set -eu

# cmd.sh


#/usr/local/spark/spark-2.4.2-bin-hadoop2.7/sbin/start-all.sh
$SPARK_HOME/sbin/start-all.sh

# 该容器永远不会退出
tail -f /dev/null