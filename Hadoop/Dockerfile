FROM centos:7

# 作者信息
MAINTAINER jugg <23335096@qq.com>

RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
&& curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
&& yum makecache

# 安装必要的工具并建立必要的文件夹
RUN yum install -y rsync vim openssl openssh-server
ENV HADOOP_TMP_DIR /data/hadoop/tmp
ENV HADOOP_NAMENODE_DIR /data/hadoop/hdfs/namenode
ENV HADOOP_DATANODE_DIR /data/hadoop/hdfs/datanode
RUN mkdir -p $HADOOP_TMP_DIR $HADOOP_NAMENODE_DIR $HADOOP_DATANODE_DIR


# 修改sshd_config以及ssh_config 文件
RUN sed -i 's/PermitRootLogin prohibit-password/ PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config
RUN sed -i 's/#   StrictHostKeyChecking ask/StrictHostKeyChecking no/' /etc/ssh/ssh_config

# 配置免密码登录
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys
RUN chmod 0700 ~/.ssh

# 配置环境变量
ENV JAVA_HOME /usr/local/java/jdk1.8.0_211
ENV HADOOP_HOME /usr/local/hadoop/hadoop-3.2.0
ENV PATH $JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

ENV LD_LIBRARY_PATH $HADOOP_HOME/lib/native
ENV HADOOP_CONF_DIR $HADOOP_HOME/etc/hadoop
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar


# 将下载并配置好的Hadoop、Java、Spark以及Zeppelin放在适当位置
ADD ./hadoop-3.2.0.tar.gz /usr/local/hadoop
ADD ./jdk-8u211-linux-x64.tar.gz /usr/local/java

# 配置hadoop
COPY conf/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh
COPY conf/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml
COPY conf/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml
COPY conf/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml
COPY conf/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml
RUN chmod +x $HADOOP_HOME/etc/hadoop/hadoop-env.sh


# 格式化Hadoop HDFS的namenode
WORKDIR $HADOOP_NAMENODE_DIR
RUN rm -rf *
WORKDIR $HADOOP_DATANODE_DIR
RUN rm -rf *
WORKDIR $HADOOP_TMP_DIR
RUN rm -rf *
WORKDIR $HADOOP_HOME
RUN bin/hdfs namenode -format


# 将启动脚本start.sh放置在合适路径
COPY start.sh /usr/local/start.sh
RUN chmod 755 /usr/local/start.sh


# 对外暴露22,50070,8088端口. 50070查看HDFS情况，8088查看Yarn运行情况
EXPOSE 22 50070 8088


CMD ["/usr/local/start.sh"]