ARG JDK_VERSION=11
ARG JDK_ARCH=amd64

ARG USERNAME=hadoop
ARG USER_GROUP=${USERNAME}

ARG HADOOP_NAME=hadoop
ARG HADOOP_VERSION=3.3.6
ARG HADOOP_DIR=https://dlcdn.apache.org/hadoop/common
ARG HADOOP_URL=${HADOOP_DIR}/${HADOOP_NAME}-${HADOOP_VERSION}

ARG HADOOP_TAR=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz
ARG HADOOP_TAR_ASC=${HADOOP_NAME}-${HADOOP_VERSION}.tar.gz.asc

ARG HADOOP_TAR_URL=${HADOOP_URL}/${HADOOP_TAR}
ARG HADOOP_TAR_ASC_URL=${HADOOP_URL}/${HADOOP_TAR_ASC}

ARG HADOOP_KEYS=${HADOOP_DIR}/KEYS

ARG TINI_VERSION=v0.19.0

FROM amazoncorretto:${JDK_VERSION} as amd64

ARG TINI_VERSION

ADD --chown=1000:1000 --chmod=700 https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini

FROM bellsoft/liberica-openjdk-centos:${JDK_VERSION}-aarch64 as arm64

ARG TINI_VERSION

ADD --chown=1000:1000 --chmod=700 https://github.com/krallin/tini/releases/download/v0.19.0/tini-arm64 /tini

FROM ${JDK_ARCH} as setup-pkgs

RUN yum update -y && yum install which tar procps gzip shadow-utils hostname -y && \
  yum clean all -y && \
  rm -rf /var/cache/yum && \
  true

FROM setup-pkgs as setup-users

ARG USERNAME
ARG USER_GROUP

RUN echo ${USER_GROUP}
RUN echo ${USERNAME}

RUN groupadd -g 1000 -r ${USER_GROUP} && \
  useradd -u 1000 -m -g ${USER_GROUP} ${USERNAME}  && \
  true

RUN chown -R ${USERNAME}:${USER_GROUP} /opt

FROM setup-users as get-hadoop

ARG USERNAME

ARG HADOOP_VERSION
ARG HADOOP_NAME

ARG HADOOP_TAR
ARG HADOOP_TAR_ASC

ARG HADOOP_TAR_URL
ARG HADOOP_TAR_ASC_URL

ARG HADOOP_URL

ARG HADOOP_KEYS

USER ${USERNAME}

RUN curl --fail -Lo /opt/KEYS ${HADOOP_KEYS} && \
  # FIXME `|| true` should be temporary until https://issues.apache.org/jira/browse/HADOOP-19006 is fixed
  gpg --import /opt/KEYS || true && \
  curl --fail -Lo /opt/${HADOOP_TAR} ${HADOOP_TAR_URL} && \
  curl --fail -Lo /opt/${HADOOP_TAR_ASC} ${HADOOP_TAR_ASC_URL} && \
  gpg --verify /opt/${HADOOP_TAR_ASC} /opt/${HADOOP_TAR} && \
  printf "\033[32mExtracting ${HADOOP_TAR} to /opt \033[0m" && \
  tar -C /opt --checkpoint=10000 --checkpoint-action=dot -xf /opt/${HADOOP_TAR} --transform "s,${HADOOP_NAME}-${HADOOP_VERSION},${HADOOP_NAME}," && \
  rm -v /opt/${HADOOP_TAR} /opt/KEYS /opt/${HADOOP_TAR_ASC} && \
  true

FROM get-hadoop as setup-hadoop

ARG USERNAME
ARG USER_GROUP

COPY --chmod=700 --chown=${USERNAME}:${USER_GROUP} bin/* /bin/

RUN mkdir /opt/configmanager && \
  cp /bin/ConfigManager.java /opt/configmanager && \
  javac /opt/configmanager/ConfigManager.java && \
  jar cfe /opt/configmanager/hadoop-starter-config-manager.jar opt.configmanager.ConfigManager /opt/configmanager/*.class && \
  echo '<configuration/>' > /opt/hadoop/etc/hadoop/core-site.xml && \
  echo '<configuration/>' > /opt/hadoop/etc/hadoop/hdfs-site.xml && \
  echo '<configuration/>' > /opt/hadoop/etc/hadoop/yarn-site.xml && \
  echo '<configuration/>' > /opt/hadoop/etc/hadoop/mapred-site.xml && \
  mkdir /opt/hadoop/logs && \
  /opt/hadoop/bin/hdfs namenode -format && \
  true

FROM setup-hadoop as setup-env

ARG HADOOP_VERSION

LABEL com.github.neshkeev.image.author="https://github.com/neshkeev" \
      com.github.neshkeev.image.title="Apache Hadoop" \
      com.github.neshkeev.image.description="Hadoop Cluster" \
      com.github.neshkeev.image.arch="${TARGETPLATFORM}" \
      com.github.neshkeev.image.vendor="neshkeev" \
      com.github.neshkeev.image.os.name="$(cat /etc/os-release)" \
      com.github.neshkeev.image.jvm="$(java --version)" \
      com.github.neshkeev.image.source="https://github.com/neshkeev/containers/tree/master/hadoop" \
      com.github.neshkeev.image.version="${HADOOP_VERSION}"

ENV OS_ARCH="${TARGETARCH:-amd64}" \
    OS_FLAVOUR="amazonlinux-2" \
    OS_NAME="linux"

ENV HADOOP_HOME=/opt/${HADOOP_NAME}
ENV PATH=/opt/${HADOOP_NAME}/bin:${PATH}

WORKDIR /opt/${HADOOP_NAME}

ENTRYPOINT [ "/tini", "--", "/bin/entrypoint"]
CMD [ "/bin/single-node-cluster" ]
