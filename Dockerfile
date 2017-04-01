FROM debian:8

ENV DCC_VERSION=1.3.159
ENV DCC_SHA256=064144a1f01bda7cdc3e8b8f721b2b73df53bf7b293c1c672244eada9776ac89

RUN \
  apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y curl gcc \
  ca-certificates libc-dev make \

  && curl -L https://www.dcc-servers.net/dcc/source/old/dcc-${DCC_VERSION}.tar.Z -o dcc-${DCC_VERSION}.tar.Z \
  && echo -n "$DCC_SHA256  dcc-${DCC_VERSION}.tar.Z" | sha256sum -c - \
  && zcat dcc-${DCC_VERSION}.tar.Z | tar xvf - \
  && cd dcc-${DCC_VERSION} \
  && ./configure --disable-dccm \
  && make install \
  && rm -rf /dcc-${DCC_VERSION} \
  && rm /dcc-${DCC_VERSION}.tar.Z \

  && apt-get purge -y --auto-remove curl gcc ca-certificates libc-dev make \
  && rm -rf /var/lib/apt/lists/*

COPY dcc_conf /var/dcc/dcc_conf

CMD [ "/var/dcc/libexec/rcDCC", "-m", "dccifd", "start" ]
