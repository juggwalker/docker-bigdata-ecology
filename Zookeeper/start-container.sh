#!/bin/sh


docker run -d --name zk-master --add-host hadoop-master:127.0.0.1 -p 2181:2181 -v //d/docker-bigdata-ecology/tmpdata/zk-data:/data zookeeper:master

