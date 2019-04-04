FROM debian:9.8-slim

ENV \
  DCC_VERSION=1.3.163 \
  DCC_SHA256=195195b79ee15253c4caf48d4ca3bf41b16c66a8cb9a13984a1dc4741d7f6735 \
  USER_UID=1000 \
  USER_GID=1000

RUN \
  apt-get update \
  \
  && apt-get install --no-install-recommends --no-install-suggests -y \
    ca-certificates \
    curl \
    gcc \
    libc-dev \
    make \
  \
  && curl -L https://www.dcc-servers.net/dcc/source/old/dcc-${DCC_VERSION}.tar.Z -o dcc-${DCC_VERSION}.tar.Z \
  && echo -n "$DCC_SHA256  dcc-${DCC_VERSION}.tar.Z" | sha256sum -c - \
  && zcat dcc-${DCC_VERSION}.tar.Z | tar xvf - \
  && cd dcc-${DCC_VERSION} \
  && ./configure --disable-dccm \
  && make install \
  && rm -rf /dcc-${DCC_VERSION} \
  && rm /dcc-${DCC_VERSION}.tar.Z \
  \
  && apt-get purge -y --auto-remove \
    ca-certificates \
    curl \
    gcc \
    libc-dev \
    make \
  && rm -rf /var/lib/apt/lists/*

COPY dcc_conf /var/dcc/dcc_conf
COPY start.sh /usr/local/bin/start.sh

EXPOSE 10030

CMD ["/usr/local/bin/start.sh"]
