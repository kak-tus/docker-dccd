FROM debian:8

COPY dcc.tar.Z_SHA256SUMS /dcc.tar.Z_SHA256SUMS

RUN \
  apt-get update \
  && apt-get install --no-install-recommends --no-install-suggests -y curl gcc \
  ca-certificates libc-dev make \

  && curl -L https://www.dcc-servers.net/dcc/source/dcc.tar.Z -o dcc.tar.Z \
  && sha256sum -c dcc.tar.Z_SHA256SUMS \
  && zcat dcc.tar.Z | tar xvf - \
  && cd dcc-1.3.158 \
  && ./configure --disable-dccm \
  && make install \
  && rm -rf /dcc-1.3.158 \
  && rm /dcc.tar.Z /dcc.tar.Z_SHA256SUMS \

  && apt-get purge -y curl gcc ca-certificates libc-dev make \
  && rm -rf /var/lib/apt/lists/*

COPY dcc_conf /var/dcc/dcc_conf

CMD /var/dcc/libexec/dccifd -b -p *,10030,10.32.1.1-192.168.255.255
