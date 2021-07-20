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
    openssh-client \
    gfortran \
    --no-install-recommends && rm -r /var/lib/apt/lists/* \
    && wget ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz -O /tmp/wgrib2.tgz \
    && mkdir -p /usr/local/grib2/ \
    && tar -xf /tmp/wgrib2.tgz -C /tmp/ \
    && rm -r /tmp/wgrib2.tgz \
    && mv /tmp/grib2/ /usr/local/grib2/ \
    && cd /usr/local/grib2/grib2 && make \
    && ln -s /usr/local/grib2/grib2/wgrib2/wgrib2 /usr/local/bin/wgrib2 \
    && apt-get -y autoremove build-essential

VOLUME /srv/
VOLUME /opt/
WORKDIR /opt/
CMD ["/bin/bash", "entrypoint.sh"]
