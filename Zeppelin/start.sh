#!/bin/sh
set -eu

#start.sh

echo "127.0.0.1    singlenode​" >> /etc/hosts

/usr/local/hadoop/hadoop-3.2.0/sbin/stop-all.sh

/usr/local/hadoop/hadoop-3.2.0/sbin/start-all.sh

/usr/local/spark/spark-2.4.2-bin-hadoop2.7/sbin/start-all.sh

/usr/local/zeppelin/zeppelin-0.8.1-bin-all/bin/zeppelin-daemon.sh start
