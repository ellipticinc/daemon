FROM debian:stable-slim

RUN apt-get update -y \
  && apt-get install -y curl gnupg gosu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

ARG VERSION=0.14.0.2
ARG DAEMON_FILE=dashcore-${VERSION}-x86_64-linux-gnu.tar.gz 
ARG SHA256SUMS_ASC=SHA256SUMS.asc
ARG PATH=/opt/bitcoin-abc-${VERSION}/bin:$PATH

RUN curl -SLO https://github.com/dashpay/dash/releases/download/v${VERSION}/${SHA256SUMS_ASC} \
  && curl -SLO https://github.com/dashpay/dash/releases/download/v${VERSION}/${DAEMON_FILE} \
  && grep " ${DAEMON_FILE}\$" ${SHA256SUMS_ASC} | sha256sum -c - \
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

COPY docker-entrypoint.sh /entrypoint.sh
COPY dash.conf /dash.conf

EXPOSE 8332 8333

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["dashd"]
