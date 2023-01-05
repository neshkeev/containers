ARG HADOOP_URL=https://dlcdn.apache.org/hadoop/common/stable
ARG HADOOP_NAME=hadoop
ARG HADOOP_VERSION=3.3.4

ARG HADOOP_TAR=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz
ARG HADOOP_TAR_CHECK=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz.sha512

ARG HADOOP_TAR_URL=${HADOOP_URL}/${HADOOP_TAR}
ARG HADOOP_TAR_CHECK_URL=${HADOOP_URL}/${HADOOP_TAR_CHECK}

FROM amazoncorretto:11.0.17 as jdk

FROM jdk as setup-pkgs

RUN yum update -y && yum install tar gzip openssh-server openssh-clients shadow-utils hostname -y && \
  yum clean all -y

FROM setup-pkgs as setup-users

RUN groupadd -r hadoop && \
  useradd -m -g hadoop hdfs && \
  useradd -m -g hadoop yarn && \
  true

RUN chown -R hdfs:hadoop /opt

FROM setup-users as setup-ssh

RUN ssh-keygen -A

USER yarn
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

USER hdfs
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys

FROM setup-ssh as get-hadoop

ARG HADOOP_VERSION
ARG HADOOP_NAME

ARG HADOOP_TAR
ARG HADOOP_TAR_CHECK

ARG HADOOP_TAR_URL
ARG HADOOP_TAR_CHECK_URL

USER hdfs

WORKDIR /opt

RUN curl -LO ${HADOOP_TAR_URL} && \
  curl -LO ${HADOOP_TAR_CHECK_URL} && \
  sha512sum -c ${HADOOP_TAR_CHECK} && \
  printf "\033[32mExtracting ${HADOOP_TAR} to $(pwd) \033[0m" && \
  tar --checkpoint=10000 --checkpoint-action=dot -xf ${HADOOP_TAR} --transform "s,${HADOOP_NAME}-${HADOOP_VERSION},${HADOOP_NAME}," && \
  rm ${HADOOP_TAR}

FROM get-hadoop as setup-hadoop

USER hdfs

WORKDIR /opt/hadoop

COPY conf/core-site.xml etc/hadoop/core-site.xml
COPY conf/hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY conf/mapred-site.xml etc/hadoop/mapred-site.xml
COPY conf/yarn-site.xml etc/hadoop/yarn-site.xml

RUN umask 0002 && \
  bin/hdfs namenode -format

FROM setup-hadoop as setup-env

USER root

COPY entrypoint /bin/entrypoint
COPY start-yarn-cluster /bin/start-yarn-cluster
COPY hsh /bin/hsh

RUN chmod a+x /bin/entrypoint && \
 chmod a+x /bin/start-yarn-cluster && \
 chmod a+x /bin/hsh && \
 true

RUN echo "export JAVA_HOME=${JAVA_HOME}" > /etc/profile.d/custom_env.sh && \
  echo 'export PATH=/opt/hadoop/bin:/opt/hadoop/sbin:${PATH}' >> /etc/profile.d/custom_env.sh && \
  echo 'umask 0002' >> /etc/profile.d/custom_env.sh && \
  true

ENTRYPOINT [ "/bin/entrypoint" ]
