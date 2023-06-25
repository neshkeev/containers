ARG HADOOP_NAME=hadoop
ARG HADOOP_VERSION=3.3.4
ARG HADOOP_DIR=https://dlcdn.apache.org/hadoop/common
ARG HADOOP_URL=${HADOOP_DIR}/${HADOOP_NAME}-${HADOOP_VERSION}

ARG HADOOP_TAR=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz
ARG HADOOP_TAR_ASC=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz.asc

ARG HADOOP_TAR_URL=${HADOOP_URL}/${HADOOP_TAR}
ARG HADOOP_TAR_ASC_URL=${HADOOP_URL}/${HADOOP_TAR_ASC}

ARG HADOOP_KEYS=${HADOOP_DIR}/KEYS

FROM amazoncorretto:8 as jdk

FROM jdk as setup-pkgs

RUN yum update -y && yum install which tar procps gzip openssh-server openssh-clients shadow-utils hostname -y && \
  yum clean all -y && \
  rm -rf /var/cache/yum && \
  amazon-linux-extras install python3.8 && \
  ln $(which python3.8) /usr/bin/python3 && \
  true

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
  chmod 0600 ~/.ssh/authorized_keys && \
  true

USER hdfs
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
  cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
  chmod 0600 ~/.ssh/authorized_keys && \
  true

FROM setup-ssh as get-hadoop

ARG HADOOP_VERSION
ARG HADOOP_NAME

ARG HADOOP_TAR
ARG HADOOP_TAR_ASC

ARG HADOOP_TAR_URL
ARG HADOOP_TAR_ASC_URL

ARG HADOOP_URL

ARG HADOOP_KEYS

USER hdfs

WORKDIR /opt

RUN curl --fail -LO ${HADOOP_KEYS} && \
  gpg --import KEYS && \
  curl --fail -LO ${HADOOP_TAR_URL} && \
  curl --fail -LO ${HADOOP_TAR_ASC_URL} && \
  gpg --verify ${HADOOP_TAR_ASC} ${HADOOP_TAR} &&\
  printf "\033[32mExtracting ${HADOOP_TAR} to $(pwd) \033[0m" && \
  tar --checkpoint=10000 --checkpoint-action=dot -xf ${HADOOP_TAR} --transform "s,${HADOOP_NAME}-${HADOOP_VERSION},${HADOOP_NAME}," && \
  rm -v ${HADOOP_TAR} KEYS ${HADOOP_TAR_ASC}

FROM get-hadoop as setup-hadoop

USER hdfs

WORKDIR /opt/hadoop

COPY conf/core-site.xml etc/hadoop/core-site.xml
COPY conf/hdfs-site.xml etc/hadoop/hdfs-site.xml
COPY conf/mapred-site.xml etc/hadoop/mapred-site.xml
COPY conf/yarn-site.xml etc/hadoop/yarn-site.xml

RUN umask 0002 && \
  mkdir logs && \
  bin/hdfs namenode -format

FROM setup-hadoop as setup-env

ARG HADOOP_VERSION

LABEL com.github.neshkeev.image.author="https://github.com/neshkeev" \
      com.github.neshkeev.image.description="Single Node Cluster Hadoop" \
      com.github.neshkeev.image.ref.name="${HADOOP_VERSION}-amazonlinux-2" \
      com.github.neshkeev.image.jvm="Amazon Corretto 1.8" \
      com.github.neshkeev.image.source="https://github.com/neshkeev/containers/tree/master/hadoop" \
      com.github.neshkeev.image.title="Apache Hadoop" \
      com.github.neshkeev.image.vendor="neshkeev" \
      com.github.neshkeev.image.version="${HADOOP_VERSION}"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="amazonlinux-2" \
    OS_NAME="linux"

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
