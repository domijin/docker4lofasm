# Copyright (C) 2018 by Dongming Jin
# Licensed under the Academic Free License version 3.0
# This program comes with ABSOLUTELY NO WARRANTY.
# You are free to modify and redistribute this code as long
# as you do not remove the above attribution and reasonably
# inform receipients that you have modified the original work.

FROM debian:latest  
# FROM debian:stable  # 20180426 version

MAINTAINER Dongming Jin "dongming.jin@utrgv.edu"

# Switch account to root and adding user accounts and password. or not
USER root
RUN echo "root:Docker!" | chpasswd

# Create lof user which will be used to run commands with reduced privileges. or not
RUN adduser --disabled-password --gecos 'unprivileged user' lof && \
    echo "lof:lof" | chpasswd && \
    mkdir -p /home/lof/.ssh && \
    chown -R lof:lof /home/lof/.ssh
    
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.4.10-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    apt-get clean

RUN pip install --upgrade pip  # upgrade to 10.0.1
RUN apt-get install -y build-essential  # install compliers

# RUN apt-get install -y mlocate
# RUN conda install -y jupyter

# switch to the user
USER lof
ENV HOME /home/lof
WORKDIR $HOME
# get lofasmio c tool
RUN git clone https://github.com/teviet/lofasmio.git
RUN cd lofasmio && make  

# get lofasm python tool
RUN git clone https://github.com/arcc/lofasm.git
# python setup require root permission
USER root
RUN cd /home/lof/lofasm && pip install -r requirements.txt && python setup.py install

# Create space for ssh deamon and update the system
RUN mkdir /var/run/sshd && \
    apt-get -y check && \
    apt-get -y update && \
    apt-get install -y apt-utils apt-transport-https software-properties-common && \
    apt-get -y upgrade


# desktop environment for easy use, disable for server
RUN apt-get -y install openssh-server 
RUN apt-get -y install lxde-core 
RUN apt-get -y install tightvncserver  

# install basic gui app for easier use
RUN apt-get -y install midori  # web browser
RUN apt-get -y install leafpad  # text editor
RUN apt-get -y install gv  # eps viewer, or ghostscript

EXPOSE 22 5901 8888
CMD ["/usr/sbin/sshd", "-D"]

