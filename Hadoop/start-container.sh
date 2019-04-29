


docker run --rm --name hadoop-master --add-host hadoop-master:127.0.0.1 -p 9870:9870 -p 8088:8088 -v /home/dockerdata/hadoop-data:/data hadoop:master