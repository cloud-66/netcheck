FROM debian:stable-slim as fetcher
COPY build/fetch_binaries.sh /tmp/fetch_binaries.sh

RUN apt-get update && apt-get install -y \
  curl \
  wget

RUN /tmp/fetch_binaries.sh

FROM alpine:3.15.0
RUN set -ex \
    && echo "http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && echo "http://nl.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk update \
    && apk upgrade \
    && apk add --no-cache \
    bash \
    kafkacat \
    tcptraceroute \
    tcpdump \
    wget

# Installing termshark
COPY --from=fetcher /tmp/termshark /usr/local/bin/termshark

USER root
WORKDIR /root

CMD ["bash"]