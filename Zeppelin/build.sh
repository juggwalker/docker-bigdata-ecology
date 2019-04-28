#!/bin/sh

echo ""

echo -e "\nbuild hadoop-spark-zeppelin image\n"
sudo docker build -t hsz:0.0.1 .


echo ""