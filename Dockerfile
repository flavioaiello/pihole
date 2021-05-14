FROM debian:buster-slim

ARG TARGETPLATFORM
ARG S6_VERSION=v1.22.1.0
ARG PIHOLE_CORE_VERSION=v5.1.2
ARG PIHOLE_WEB_VERSION=v5.1.1
ARG PIHOLE_FTL_VERSION=v5.2
ARG DEBIAN_FRONTEND=noninteractive
ARG PIHOLE_SKIP_OS_CHECK=true

RUN apt-get update ;\
    apt-get install --no-install-recommends -y curl procps ca-certificates netcat-openbsd

COPY Dockerfile.sh /
COPY rootfs /

# Runtime container environment
ENV S6_LOGGING=0 \
    S6_KEEP_ENV=1 \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    PIHOLE_DNS_USER=pihole \
    PATH=/opt/pihole:${PATH}

RUN /Dockerfile.sh ;\
    rm -rf /Dockerfile.sh /var/cache/apt/archives /var/lib/apt/lists/*

EXPOSE 53/udp
EXPOSE 53/tcp
EXPOSE 80/tcp
EXPOSE 443/tcp

WORKDIR /
ENTRYPOINT ["/s6-init"]
