FROM ubuntu:18.04

# 作者信息
MAINTAINER jugg <23335096@qq.com>

# 复制本地文件到镜像
ADD sources.list /etc/apt/



# 安装必要的工具并建立必要的文件夹
RUN apt-get update && apt-get install -y sudo
RUN sudo apt-get install -y openssh-server rsync vim supervisor
RUN mkdir /var/run/sshd
ENV HADOOP_TMP_DIR /data/hadoop/tmp
ENV HADOOP_NAMENODE_DIR /data/hadoop/hdfs/namenode
ENV HADOOP_DATANODE_DIR /data/hadoop/hdfs/datanode
RUN sudo mkdir -p $HADOOP_TMP_DIR $HADOOP_NAMENODE_DIR $HADOOP_DATANODE_DIR


# 修改sshd_config以及ssh_config 文件
RUN sudo sed -i 's/PermitRootLogin prohibit-password/ PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sudo sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config

# 配置免密码登录
RUN sudo ssh-keygen -t rsa -f ~/.ssh/id_rsa
RUN sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN sudo chmod 0600 ~/.ssh/authorized_keys
RUN sudo chmod 0700 ~/.ssh

# 配置环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_211
ENV SPARK_HOME /usr/local/spark/spark-2.4.2-bin-hadoop2.7
ENV HADOOP_HOME /usr/local/hadoop/hadoop-3.2.0
ENV ZEPPELIN_HOME /usr/local/zeppelin/zeppelin-0.8.1-bin-all
ENV PATH $JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$PATH

ENV LD_LIBRARY_PATH $HADOOP_HOME/lib/native
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV YARN_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


# 将下载并配置好的Hadoop、Java、Spark以及Zeppelin放在适当位置
ADD ./packages/hadoop-3.2.0.tar.gz /usr/local/hadoop
ADD ./packages/jdk-8u211-linux-x64.tar.gz /usr/local/java
ADD ./packages/spark-2.4.2-bin-hadoop2.7.tgz /usr/local/spark
ADD ./packages/zeppelin-0.8.1-bin-all.tgz /usr/local/zeppelin

# 配置hadoop
COPY etc/hadoop/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY etc/hadoop/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY etc/hadoop/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY etc/hadoop/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY etc/hadoop/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
RUN sudo chmod +x $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# 配置spark
COPY etc/spark/slaves $SPARK_HOME/conf/slaves
COPY etc/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
COPY etc/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh

# 配置zeppelin
COPY etc/zeppelin/zeppelin-env.sh $ZEPPELIN_HOME/conf/zeppelin-env.sh
COPY etc/zeppelin/zeppelin-site.xml $ZEPPELIN_HOME/conf/zeppelin-site.xml

# 格式化Hadoop HDFS的namenode
WORKDIR $HADOOP_NAMENODE_DIR
RUN sudo rm -rf *
WORKDIR $HADOOP_DATANODE_DIR
RUN sudo rm -rf *
WORKDIR $HADOOP_TMP_DIR
RUN sudo rm -rf *
WORKDIR $HADOOP_HOME
RUN sudo bin/hdfs namenode -format


# 将启动脚本start.sh放置在合适路径
COPY start.sh /usr/local/start.sh


# 使用supervisord来管理
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN sudo chmod 755 /etc/supervisor/conf.d/supervisord.conf


# 对外暴露22,50070,8080,4040,8090端口
EXPOSE 22 50070 8080 4040 8090

# 设置container启动时执行的操作
CMD ["/usr/bin/supervisord"]