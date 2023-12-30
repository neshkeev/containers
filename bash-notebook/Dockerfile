FROM jupyter/base-notebook

USER root

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y git vim curl unzip fontconfig ca-certificates gnupg && \
  install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
  sudo chmod a+r /etc/apt/keyrings/docker.gpg && \
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list && \
  sudo apt-get update -y && \
  apt-get install -y docker-ce-cli docker-compose-plugin && \
  groupadd docker && \
  usermod -aG docker jovyan && \
  true

USER jovyan

RUN pip install --upgrade pip && \
  pip install bash_kernel && \
  python -m bash_kernel.install && \
  true

ENV EDITOR=vim

COPY --chown=jovyan:jovyan ./conf/jupyterlab-settings.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
COPY --chown=jovyan:jovyan ./conf/jupyterlab-notification.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/notification.jupyterlab-settings
COPY --chown=jovyan:jovyan ./conf/jupyterlab-editor-settings.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

WORKDIR /home/jovyan
