FROM debian:stable-slim

RUN useradd -r monero \
  && apt-get update -y \
  && apt-get install -y curl gnupg gosu bzip2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

ARG VERSION=0.14.1.2
ARG DAEMON_FILE=monero-linux-x64-v$VERSION.tar.bz2
ARG PATH=/opt/bitcoin-abc-${VERSION}/bin:$PATH

RUN curl -SLO -o /hashes.asc https://getmonero.org/downloads/hashes.txt \
	&& curl -SLO https://downloads.getmonero.org/cli/monero-linux-x64-v${VERSION}.tar.bz2 \
  && grep " ${DAEMON_FILE}\$" hashes.asc | sha256sum -c - \
  && tar --strip=2 -xjvf *.tar.bz2 -C /usr/local/bin \
  && rm *.tar.bz2

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 18080 18081

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["monerod"]
