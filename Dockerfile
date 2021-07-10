FROM docker.io/debian:bullseye-slim AS builder

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

# Install Python
ARG PYTHON_VERSION=3.8.2

RUN apt-get update && apt-get install -y xz-utils make zlib1g-dev
RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz -O /tmp/python-$PYTHON_VERSION.tar.xz
RUN tar -xf /tmp/python-$PYTHON_VERSION.tar.xz -C /tmp/
WORKDIR /tmp/Python-$PYTHON_VERSION/
RUN ./configure --enable-optimizations
RUN make -j 4
RUN make altinstall
RUN temp=$(echo "/usr/local/bin/python"$PYTHON_VERSION | rev | cut -c 3- | rev) && cp $temp /usr/local/bin/python

RUN apt-get -y autoremove build-essential

FROM docker.io/debian:bullseye-slim
ENV FC=gfortran
ENV CC=gcc
RUN apt-get update && apt-get install -y gfortran
COPY --from=builder /usr/local/ /usr/local/

VOLUME /srv/
VOLUME /opt/
WORKDIR /opt/
CMD ["/bin/bash", "entrypoint.sh"]