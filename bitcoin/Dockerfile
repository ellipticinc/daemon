FROM debian:stable-slim

RUN apt-get update -y \
  && apt-get install -y curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION=0.18.0
ARG PATH=/opt/bitcoin-${VERSION}/bin:$PATH

RUN curl -SL https://bitcoin.org/laanwj-releases.asc | gpg --batch --import \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/SHA256SUMS.asc \
  && curl -SLO https://bitcoin.org/bin/bitcoin-core-${VERSION}/bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz \
  && gpg --verify SHA256SUMS.asc \
  && grep " bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz\$" SHA256SUMS.asc | sha256sum -c - \
  && tar -xzf *.tar.gz -C /opt \
  && rm *.tar.gz *.asc

COPY docker-entrypoint.sh /entrypoint.sh
COPY bitcoin.conf /bitcoin.conf

EXPOSE 8332 8333

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["bitcoind"]
