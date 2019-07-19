FROM debian:stable-slim

RUN apt-get update -y \
  && apt-get install -y curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

RUN gpg --keyserver "pgp.mit.edu" --recv-keys FE3348877809386C

ARG VERSION=0.17.1
ARG DAEMON_FILE=litecoin-${VERSION}-x86_64-linux-gnu.tar.gz 
ARG SHA256SUMS_ASC=litecoin-${VERSION}-linux-signatures.asc
ARG PATH=/opt/bitcoin-abc-${VERSION}/bin:$PATH

RUN curl -SLO https://download.litecoin.org/litecoin-${VERSION}/linux/${SHA256SUMS_ASC} \
  && curl -O https://download.litecoin.org/litecoin-${VERSION}/linux/${DAEMON_FILE} \
  && gpg --verify ${SHA256SUMS_ASC} \
  && grep " ${DAEMON_FILE}\$" ${SHA256SUMS_ASC} | sha256sum -c - \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh
COPY litecoin.conf /litecoin.conf

EXPOSE 8332 8333

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["litecoind"]
