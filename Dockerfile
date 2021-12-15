FROM debian:bullseye-slim AS builder

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
    zip \
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

RUN apt-get install -y \
    python3-pip \
    unzip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
    boto3 \
    && rm -rf /var/cache/apk/*

# Install aws cli2
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -O awscliv2.zip
RUN unzip awscliv2.zip
RUN ./aws/install

FROM debian:bullseye-slim
ENV FC=gfortran
ENV CC=gcc
RUN apt-get update && apt-get install -y gfortran zip
COPY --from=builder /usr/local/ /usr/local/

VOLUME /srv/
VOLUME /opt/
WORKDIR /opt/
ENTRYPOINT [ "/bin/bash" ]
CMD ["/opt/entrypoint.sh"]
