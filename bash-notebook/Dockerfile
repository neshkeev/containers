FROM jupyter/base-notebook:2023-03-13

USER root
RUN apt-get update -y && \
  apt-get upgrade -y && \
  apt-get install -y git vim curl unzip fontconfig

USER jovyan

ENV EDITOR=vim

RUN pip install --upgrade pip && \
  pip install bash_kernel && \
  python -m bash_kernel.install && \
  curl -Lo /home/jovyan/.local/share/jb.zip https://download.jetbrains.com/fonts/JetBrainsMono-2.304.zip && \
  unzip -d /home/jovyan/.local/share /home/jovyan/.local/share/jb.zip && \
  fc-cache -f -v && \
  rm /home/jovyan/.local/share/jb.zip
