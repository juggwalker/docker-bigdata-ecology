#!/bin/sh

echo ""

echo -e "\nbuild zookeeper-master image. base zookeeper-3.4.14 \n"
docker build -t zookeeper:master .


echo ""