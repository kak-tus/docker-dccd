FROM debian:8

ENV DCC_VERSION=1.3.159
COPY dcc-${DCC_VERSION}.tar.Z_SHA256SUMS /dcc-${DCC_VERSION}.tar.Z_SHA256SUMS

RUN \
  apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y curl gcc \
  ca-certificates libc-dev make \

  && curl -L https://www.dcc-servers.net/dcc/source/old/dcc-${DCC_VERSION}.tar.Z -o dcc-${DCC_VERSION}.tar.Z \
  && sha256sum -c dcc-${DCC_VERSION}.tar.Z_SHA256SUMS \
  && zcat dcc-${DCC_VERSION}.tar.Z | tar xvf - \
  && cd dcc-${DCC_VERSION} \
  && ./configure --disable-dccm \
  && make install \
  && rm -rf /dcc-${DCC_VERSION} \
  && rm /dcc-${DCC_VERSION}.tar.Z /dcc-${DCC_VERSION}.tar.Z_SHA256SUMS \

  && apt-get purge -y curl gcc ca-certificates libc-dev make \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

COPY dcc_conf /var/dcc/dcc_conf

CMD [ "/var/dcc/libexec/rcDCC", "-m", "dccifd", "start", ">", "/dev/stdout" ]
