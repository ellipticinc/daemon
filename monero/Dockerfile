FROM debian:stable-slim

RUN useradd -r monero \
  && apt-get update -y \
  && apt-get install -y curl gnupg gosu bzip2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

ARG VERSION=0.14.1.2
ARG DAEMON_FILE=monero-linux-x64-v${VERSION}.tar.bz2

# copy of fluffypony key found in /utils/gpg_keys of monero project
COPY fluffypony.asc /fluffypony.asc

RUN curl -SLO https://getmonero.org/downloads/hashes.txt \
  && curl -SLO https://downloads.getmonero.org/cli/monero-linux-x64-v${VERSION}.tar.bz2 \
  && gpg --import fluffypony.asc \
  && gpg --verify hashes.txt \
  && cat hashes.txt | grep "^${DAEMON_FILE}" | cut -f2 -d" " | xargs -I{} echo "{}  ${DAEMON_FILE}" | sha256sum -c - \
  && tar -xzvf *.tar.bz2 -C /usr/local/bin \
  && rm *.tar.bz2

ENV PATH=/usr/local/bin/monero-x86_64-linux-gnu:$PATH
COPY docker-entrypoint.sh /entrypoint.sh
COPY bitmonero.conf /bitmonero.conf

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["monerod"]
