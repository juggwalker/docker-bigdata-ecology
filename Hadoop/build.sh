#!/bin/sh

echo ""

echo -e "\nbuild hadoop-master image. base Hadoop3.2.0 \n"
sudo docker build -t hadoop:master .


echo ""