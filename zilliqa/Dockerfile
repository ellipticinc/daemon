ARG VERSION=v5.1.1

FROM zilliqa/zilliqa:$VERSION

USER root
RUN apt-get update -y \
  && apt-get install -y curl gnupg gosu bzip2 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && set -ex

COPY docker-entrypoint.sh /entrypoint.sh

# zilliqa specific stuff:
RUN curl -O https://mainnet-join.zilliqa.com/seed-configuration.tar.gz \
  && tar -zxvf seed-configuration.tar.gz

RUN mkdir -p /home/daemon/.daemon
RUN chmod 700 /home/daemon/.daemon
RUN chown -R daemon /home/daemon/.daemon

ENTRYPOINT ["sh", "/entrypoint.sh"]

CMD ["zilliqa"]

