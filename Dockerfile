FROM sequenceiq/pam:ubuntu-14.04
MAINTAINER Gabriel Figueiredo <gabriel.figueiredo@imperial.ac.uk>

RUN apt-get -y update && apt-get -y install nano curl git python-dev python-pip && pip install supervisor Flask pyzmq bottle psutil 

#RUN mkdir /var/run/sshd
#RUN echo 'root:root' | chpasswd
#RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
#RUN sed -i 's/22/3333/' /etc/ssh/sshd_config 
#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

# make ssh dir
RUN mkdir /root/.ssh

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa
RUN chmod 700 /root/.ssh/id_rsa
RUN chown -R root:root /root/.ssh
RUN echo "Host *\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

ADD build_harness_iaas /
ADD start_harness_iaas /
WORKDIR /
RUN ./build_harness_iaas 
RUN rm -rf ./build_harness_iaas
WORKDIR /harness
ENTRYPOINT ["/start_harness_iaas"]
CMD ["10.1.0.2", "638e4593-0586-4e35-9a2b-66b47a55cb45", "5ad08aeb-15c8-48de-badc-3e5bcdefa269", "fixed"]






