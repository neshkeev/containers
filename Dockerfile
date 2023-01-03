FROM amazoncorretto:11.0.17 as jdk

FROM jdk as setup-pkgs

RUN yum install tar gzip openssh-server openssh-clients shadow-utils hostname telnet iputils -y && \
  yum clean all && \
  systemctl enable sshd

FROM setup-pkgs as setup-users

RUN groupadd -r hadoop && \
  useradd -m -g hadoop hadoop

RUN chmod -R 777 /opt

USER hadoop
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

FROM setup-users as get-hadoop

ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/stable
ARG HADOOP_VERSION=3.3.4
ARG HADOOP_NAME=hadoop
ARG HADOOP_TAR=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz

WORKDIR /opt
USER hadoop

RUN curl -LO ${HADOOP_URL}/${HADOOP_TAR}

RUN tar -xf ${HADOOP_TAR} --transform "s,${HADOOP_NAME}-${HADOOP_VERSION},${HADOOP_NAME},"

FROM get-hadoop

WORKDIR /opt/hadoop
USER hadoop

RUN echo '<configuration>' > etc/hadoop/core-site.xml
RUN echo '    <property>' >> etc/hadoop/core-site.xml
RUN echo '        <name>fs.defaultFS</name>' >> etc/hadoop/core-site.xml
RUN echo '        <value>hdfs://localhost:9000</value>' >> etc/hadoop/core-site.xml
RUN echo '    </property>' >> etc/hadoop/core-site.xml
RUN echo '</configuration>' >> etc/hadoop/core-site.xml

RUN echo '<configuration>' > etc/hadoop/hdfs-site.xml
RUN echo '    <property>' >> etc/hadoop/hdfs-site.xml
RUN echo '        <name>dfs.replication</name>' >> etc/hadoop/hdfs-site.xml
RUN echo '        <value>1</value>' >> etc/hadoop/hdfs-site.xml
RUN echo '    </property>' >> etc/hadoop/hdfs-site.xml
RUN echo '</configuration>' >> etc/hadoop/hdfs-site.xml

RUN cat etc/hadoop/core-site.xml
RUN cat etc/hadoop/hdfs-site.xml

RUN bin/hdfs namenode -format

USER root
USER hadoop

RUN echo 'export JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto' > /home/hadoop/.bashrc

USER root

COPY entrypoint /bin/entrypoint
RUN chmod 777 /bin/entrypoint

ENTRYPOINT [ "/bin/entrypoint" ]
