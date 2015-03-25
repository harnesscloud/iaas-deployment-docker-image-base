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

RUN git clone https://github.com/harnesscloud/crs.git && \
    git clone https://github.com/harnesscloud/irm-nova.git && \
    (cd irm-nova && git checkout a789a05308a98586ca4480e2e7c1307c7f223c44) && \
    git clone https://github.com/harnesscloud/irm-shepard.git

COPY cfg/* cfg/
COPY supervisord.conf ./
COPY start_harness_iaas ./
COPY bootstrap ./

RUN ln -sf /etc/harness-iaas/compute_list compute_list 

VOLUME /etc/harness-iaas

CMD ./start_harness_iaas
