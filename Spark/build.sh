#!/bin/sh

echo ""

echo -e "\nbuild spark image. base spark-2.4.2-bin-hadoop2.7 \n"
sudo docker build -t spark:0.0.1 .


echo ""