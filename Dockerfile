FROM ubuntu:xenial

COPY env.sh /env.sh
COPY setup.sh /setup.sh

RUN /setup.sh && \
    rm /setup.sh

COPY docker-entrypoint.sh /

EXPOSE 22
CMD    ["bash", "/docker-entrypoint.sh"]