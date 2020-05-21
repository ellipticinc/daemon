FROM zcashfr/zcash

USER root

RUN usermod -aG sudo zcash

ENV ZCASH_CONF=/home/daemon/.daemon/zcash.conf
ENV DATA_DIR=/home/daemon/.daemon

RUN mkdir -p ${DATA_DIR}
RUN chmod 700 ${DATA_DIR}

COPY zcash.conf ${ZCASH_CONF}
COPY launch-zcashd.sh /usr/local/bin/launch-zcashd.sh

RUN cp -R /home/zcash/ /home/zcash-init/

RUN chown -R zcash /home/zcash-init
RUN chown -R zcash ${DATA_DIR}
RUN apt-get update && apt-get install -y procps curl gnupg gosu

USER zcash

ENTRYPOINT ["/bin/bash", "/usr/local/bin/launch-zcashd.sh"]

EXPOSE 8233/tcp

WORKDIR /home/zcash