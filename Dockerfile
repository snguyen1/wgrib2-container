FROM docker.io/debian:bullseye-slim

ENV DEBUG true
ENV FC=gfortran
ENV CC=gcc

# Install script dependance avaible on apt source
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    build-essential \
    bzip2 \
    tar \
    amqp-tools \
    openssh-client

RUN apt-get install -y \
    gfortran \
    --no-install-recommends && rm -r /var/lib/apt/lists/*
RUN wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz -O /tmp/wgrib2.tgz
RUN mkdir -p /usr/local/grib2/
RUN tar -xf /tmp/wgrib2.tgz -C /tmp/
RUN rm -r /tmp/wgrib2.tgz
RUN mv /tmp/grib2/ /usr/local/grib2/
RUN cd /usr/local/grib2/grib2 && make
RUN ln -s /usr/local/grib2/grib2/wgrib2/wgrib2 /usr/local/bin/wgrib2
RUN apt-get -y autoremove build-essential

VOLUME /srv/
VOLUME /opt/
WORKDIR /opt/
CMD ["/bin/bash", "entrypoint.sh"]