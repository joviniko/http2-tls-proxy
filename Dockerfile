FROM ubuntu:20.04 as start
RUN apt-get update && \
    apt-get install -y build-essential libssl-dev libevent-dev zlib1g-dev libnet1-dev libpcap-dev sqlite3 libsqlite3-dev && \
    apt-get clean

FROM start as builder
WORKDIR /src
COPY sslsplit /src
RUN make

FROM start as builder-proxy
WORKDIR /src
COPY SSLproxy /src
RUN make

FROM start
COPY --from=builder /src/sslsplit /usr/local/bin/sslsplit
COPY --from=builder-proxy /src/src/sslproxy /usr/local/bin/sslproxy