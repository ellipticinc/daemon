FROM debian:stable-slim

RUN apt-get update -y \
	&& apt-get install -y curl gnupg gosu \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG VERSION=0.20.6
ARG DAEMON_FILE="bitcoin-abc-${VERSION}-x86_64-linux-gnu.tar.gz"
ARG SHA256SUMS_ASC=jasonbcox-sha256sums.${VERSION}.asc
ENV PATH=/opt/bitcoin-abc-${VERSION}/bin:$PATH

RUN curl -SLO https://download.bitcoinabc.org/${VERSION}/${SHA256SUMS_ASC} \
  && curl -SLO https://download.bitcoinabc.org/${VERSION}/linux/${DAEMON_FILE} \
  && grep " ${DAEMON_FILE}\$" ${SHA256SUMS_ASC} | sha256sum -c - \
  && tar -xzf ${DAEMON_FILE} -C /opt \
  && rm ${DAEMON_FILE} 

COPY docker-entrypoint.sh /entrypoint.sh
COPY bitcoin.conf /bitcoin.conf

EXPOSE 8332 8333

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["bitcoind"]
