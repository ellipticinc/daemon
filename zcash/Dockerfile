FROM debian:stable-slim

RUN apt-get update -y \
  && apt-get install -y curl gnupg gosu bzip2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

RUN apt-get install apt-transport-https 
RUN curl -sL https://apt.z.cash/zcash.asc | apt-key add -
RUN echo "deb [arch=amd64] https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list
RUN apt-get update && apt-get install zcash

RUN zcash-fetch-params
RUN mv /root/.zcash-params /home/daemon


COPY docker-entrypoint.sh /entrypoint.sh
COPY zcash.conf /zcash.conf

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["zcashd"]
