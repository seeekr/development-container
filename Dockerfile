FROM ubuntu:xenial

COPY env.sh /env.sh
COPY root.sh /root.sh
COPY setup.sh /setup.sh

RUN /setup.sh && \
    rm /root.sh && \
    rm /setup.sh

EXPOSE 22
CMD    ["/usr/sbin/sshd", "-D"]