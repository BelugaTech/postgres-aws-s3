FROM postgis/postgis:13-3.2

RUN mkdir /tmp/extension
WORKDIR /tmp/extension

RUN apt update && \
  apt install -y python3 python3-pip postgresql-plpython3-13 make && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*
RUN pip3 install boto3 requests
COPY aws_s3--0.0.1.sql aws_s3.control Makefile ./
RUN make install
RUN sed -i '/^EOSQL/i CREATE EXTENSION IF NOT EXISTS plpython3u\;CREATE EXTENSION IF NOT EXISTS aws_s3\;' \
  /docker-entrypoint-initdb.d/10_postgis.sh
