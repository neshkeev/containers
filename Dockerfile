FROM amazoncorretto:11.0.17 as jdk

FROM jdk as setup-pkgs

RUN yum update -y && yum install tar gzip openssh-server openssh-clients shadow-utils hostname -y && \
  yum clean all -y

FROM setup-pkgs as setup-users

RUN groupadd -r hadoop && \
  useradd -m -g hadoop hadoop

RUN chmod -R 777 /opt

FROM setup-users as setup-ssh

RUN ssh-keygen -A

USER hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

FROM setup-ssh as get-hadoop

ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/stable
ARG HADOOP_VERSION=3.3.4
ARG HADOOP_NAME=hadoop
ARG HADOOP_TAR=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz
ARG HADOOP_TAR_CHECK=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz.sha512

WORKDIR /opt
USER hadoop

RUN curl -LO ${HADOOP_URL}/${HADOOP_TAR} && \
  curl -LO ${HADOOP_URL}/${HADOOP_TAR_CHECK} && \
  sha512sum -c ${HADOOP_TAR_CHECK} && \
  tar -xf ${HADOOP_TAR} --transform "s,${HADOOP_NAME}-${HADOOP_VERSION},${HADOOP_NAME}," && \
  rm ${HADOOP_TAR}

FROM get-hadoop

WORKDIR /opt/hadoop
USER hadoop

# core-site.xml
RUN echo '<configuration>' > etc/hadoop/core-site.xml && \
 echo '    <property>' >> etc/hadoop/core-site.xml && \
 echo '        <name>fs.defaultFS</name>' >> etc/hadoop/core-site.xml && \
 echo '        <value>hdfs://localhost:9000</value>' >> etc/hadoop/core-site.xml && \
 echo '    </property>' >> etc/hadoop/core-site.xml && \
 echo '</configuration>' >> etc/hadoop/core-site.xml

# hdfs-site.xml
RUN echo '<configuration>' > etc/hadoop/hdfs-site.xml && \
  echo '    <property>' >> etc/hadoop/hdfs-site.xml && \
  echo '        <name>dfs.replication</name>' >> etc/hadoop/hdfs-site.xml && \
  echo '        <value>1</value>' >> etc/hadoop/hdfs-site.xml && \
  echo '    </property>' >> etc/hadoop/hdfs-site.xml && \
  echo '</configuration>' >> etc/hadoop/hdfs-site.xml

# mapred-site.xml
RUN echo '<configuration>' > etc/hadoop/mapred-site.xml && \
  echo '    <property>' >> etc/hadoop/mapred-site.xml && \
  echo '        <name>mapreduce.framework.name</name>' >> etc/hadoop/mapred-site.xml && \
  echo '        <value>yarn</value>' >> etc/hadoop/mapred-site.xml && \
  echo '    </property>' >> etc/hadoop/mapred-site.xml && \
  echo '    <property>' >> etc/hadoop/mapred-site.xml && \
  echo '        <name>mapreduce.application.classpath</name>' >> etc/hadoop/mapred-site.xml && \
  echo '        <value>$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/*:$HADOOP_MAPRED_HOME/share/hadoop/mapreduce/lib/*</value>' >> etc/hadoop/mapred-site.xml && \
  echo '    </property>' >> etc/hadoop/mapred-site.xml && \
  echo '</configuration>' >> etc/hadoop/mapred-site.xml

# yarn-site.xml
RUN echo '<configuration>' > etc/hadoop/yarn-site.xml && \
  echo '    <property>' >> etc/hadoop/yarn-site.xml && \
  echo '        <name>yarn.nodemanager.aux-services</name>' >> etc/hadoop/yarn-site.xml && \
  echo '        <value>mapreduce_shuffle</value>' >> etc/hadoop/yarn-site.xml && \
  echo '    </property>' >> etc/hadoop/yarn-site.xml && \
  echo '    <property>' >> etc/hadoop/yarn-site.xml && \
  echo '        <name>yarn.nodemanager.env-whitelist</name>' >> etc/hadoop/yarn-site.xml && \
  echo '        <value>JAVA_HOME,HADOOP_COMMON_HOME,HADOOP_HDFS_HOME,HADOOP_CONF_DIR,CLASSPATH_PREPEND_DISTCACHE,HADOOP_YARN_HOME,HADOOP_HOME,PATH,LANG,TZ,HADOOP_MAPRED_HOME</value>' >> etc/hadoop/yarn-site.xml && \
  echo '    </property>' >> etc/hadoop/yarn-site.xml && \
  echo '</configuration>' >> etc/hadoop/yarn-site.xml

RUN bin/hdfs namenode -format

USER root

COPY entrypoint /bin/entrypoint
COPY start-hadoop /bin/start-hadoop
COPY hsh /bin/hsh

RUN chmod a+x /bin/entrypoint && \
 chmod a+x /bin/start-hadoop && \
 chmod a+x /bin/hsh && \
 true

ENTRYPOINT [ "/bin/entrypoint" ]
