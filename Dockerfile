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
    (cd irm-nova && git checkout v1.0) && \
    git clone https://github.com/harnesscloud/irm-shepard.git

COPY cfg/* cfg/
COPY supervisord.conf ./
COPY start_harness_iaas ./
COPY bootstrap ./

RUN rm -f /harness/irm-nova/compute_list && \
    ln -sf /etc/harness-iaas/compute_list /harness/irm-nova/compute_list 
RUN rm -f /harness/crs/crs.constraints && \
    ln -sf /etc/harness-iaas/crs.constraints /harness/crs/crs.constraints

VOLUME /etc/harness-iaas

EXPOSE 8888 56789

CMD ./start_harness_iaas
