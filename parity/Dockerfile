ARG VERSION=2.5.9-stable

FROM parity/parity:v$VERSION

USER root
RUN apt-get update -y \
  && apt-get install -y curl gnupg gosu bzip2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

COPY docker-entrypoint.sh /entrypoint.sh
COPY config.toml /config.toml

RUN mkdir -p /home/daemon/.daemon
RUN chmod 700 /home/daemon/.daemon
RUN chown -R daemon /home/daemon/.daemon

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["parity"]

