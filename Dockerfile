FROM sequenceiq/pam:ubuntu-14.04
MAINTAINER Gabriel Figueiredo <gabriel.figueiredo@imperial.ac.uk>

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -y install \
        curl \
        git \
        libzmq-dev \
        python-dev \
        python-pip && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN pip install \
        bottle \
        Flask \
        psutil \
        pyzmq \
        supervisor

WORKDIR /harness
RUN git clone git@gitlab.harness-project.eu:gabe/iaas-deployment-imp.git . && \
    git submodule init && \
    submodule update

ADD start_harness_iaas /usr/local/bin

CMD /usr/local/bin/start_harness_iaas
