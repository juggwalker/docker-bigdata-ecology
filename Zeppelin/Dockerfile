FROM ubuntu:18.04

# 作者信息
MAINTAINER jugg <23335096@qq.com>

# 复制本地文件到镜像
ADD sources.list /etc/apt/


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
ENV ZEPPELIN_HOME /usr/local/zeppelin/zeppelin-0.8.1-bin-all
ENV PATH $JAVA_HOME/bin:$SPARK_HOME/bin:$SCALA_HOME/bin:$PATH
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar



# 将下载并配置好的Java、Zeppelin放在适当位置
ADD ./jdk-8u211-linux-x64.tar.gz /usr/local/java
ADD ./zeppelin-0.8.1-bin-all.tgz /usr/local/zeppelin


# 配置zeppelin
COPY conf/zeppelin-env.sh $ZEPPELIN_HOME/conf/zeppelin-env.sh
COPY conf/zeppelin-site.xml $ZEPPELIN_HOME/conf/zeppelin-site.xml


# 将启动脚本cmd.sh放置在合适路径
COPY cmd.sh /usr/local/cmd.sh
RUN chmod 755 /usr/local/cmd.sh


# 对外暴露22,8090端口
EXPOSE 22 8090

COPY entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/entrypoint.sh


WORKDIR $ZEPPELIN_HOME

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/cmd.sh"]