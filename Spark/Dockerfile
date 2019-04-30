FROM ubuntu:18.04

# 作者信息
MAINTAINER jugg <23335096@qq.com>

# 复制本地文件到镜像
ADD sources.list /etc/apt/

ENV INSTALL_SPARK_VERSION 2.4.2

# 安装必要的工具并建立必要的文件夹
RUN apt-get update && apt-get install -y sudo
RUN sudo apt-get install -y openssh-server rsync vim iputils-ping net-tools
RUN mkdir -p /var/run/sshd /root/.ssh


# 设置时区（为了获取/usr/share/zoneinfo）
RUN apt-get install -y tzdata \
&& rm /etc/localtime \
&& ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
&& date


# 修改sshd_config以及ssh_config 文件
RUN sudo sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sudo sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN echo "AuthorizedKeysFile     .ssh/authorized_keys" >> /etc/ssh/sshd_config
RUN sudo sed -i 's/#   StrictHostKeyChecking ask/    StrictHostKeyChecking no/' /etc/ssh/ssh_config

# 解决ubuntu下的mesg: ttyname failed: Inappropriate ioctl for device  问题
RUN sed -i '$d' /root/.profile && echo 'tty -s && mesg n' >> /root/.profile

# 配置免密码登录
RUN sudo ssh-keygen -t rsa -f ~/.ssh/id_rsa
RUN sudo cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN sudo chmod 0600 ~/.ssh/authorized_keys
RUN sudo chmod 0700 ~/.ssh

# 配置环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_211
ENV SCALA_HOME /usr/local/scala/scala-2.12.8
ENV SPARK_HOME /usr/local/spark/spark-$INSTALL_SPARK_VERSION-bin-hadoop2.7
ENV PATH $JAVA_HOME/bin:$SPARK_HOME/bin:$SCALA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


# 将下载并配置好的Hadoop、Java、Spark以及Zeppelin放在适当位置
ADD ./jdk-8u211-linux-x64.tar.gz /usr/local/java
ADD ./scala-2.12.8.tgz /usr/local/scala
ADD ./spark-$INSTALL_SPARK_VERSION-bin-hadoop2.7.tgz /usr/local/spark


# 配置spark
COPY etc/spark/slaves $SPARK_HOME/conf/slaves
COPY etc/spark/spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf
COPY etc/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh
RUN sudo chmod +x $SPARK_HOME/conf/spark-env.sh


# 将启动脚本start.sh放置在合适路径
COPY cmd.sh /usr/local/cmd.sh
RUN chmod 755 /usr/local/cmd.sh


# 对外暴露22,8080,4040端口, spark master web ui 默认端口为8080, 当前执行的任务页面查看端口4040,任务执行后4040不可访问
EXPOSE 22 8080 4040

COPY entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/cmd.sh"]