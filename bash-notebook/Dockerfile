FROM jupyter/base-notebook:2023-03-13

USER root

RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y git vim curl unzip fontconfig && \
  true

USER jovyan

ENV EDITOR=vim

RUN pip install --upgrade pip && \
  pip install bash_kernel && \
  python -m bash_kernel.install && \
  curl -Lo /home/jovyan/.local/share/jb.zip https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip && \
  unzip -d /home/jovyan/.local/share /home/jovyan/.local/share/jb.zip && \
  fc-cache -f -v && \
  rm /home/jovyan/.local/share/jb.zip && \
  true

USER root

COPY ./conf/jupyterlab-settings.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/themes.jupyterlab-settings
COPY ./conf/jupyterlab-notification.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/notification.jupyterlab-settings
COPY ./conf/jupyterlab-editor-settings.json /home/jovyan/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/tracker.jupyterlab-settings

RUN chown -R jovyan:users /home/jovyan/.jupyter && \
  true

USER jovyan

WORKDIR /home/jovyan
