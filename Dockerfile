# syntax=docker/dockerfile:experimental
ARG NGINX_VERSION=latest
FROM nginx:${NGINX_VERSION} as build

RUN apt-get update && \
    apt-get install -y \
        wget \
        libxml2 \
        libxslt1-dev \
        libpcre3 \
        libpcre3-dev \
        zlib1g \
        zlib1g-dev \
        openssl \
        libssl-dev \
        libtool \
        automake \
        gcc \
        g++ \
        make && \
    rm -rf /var/cache/apt

RUN wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" && \
    tar -C /usr/src -xzvf nginx-${NGINX_VERSION}.tar.gz

WORKDIR /usr/src/nginx-${NGINX_VERSION}
RUN NGINX_ARGS=$(nginx -V 2>&1 | sed -n -e 's/^.*arguments: //p') \
    ./configure \
        --with-compat \
        --with-stream \
        --with-stream_ssl_preread_module \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module ${NGINX_ARGS} && \
    make

FROM nginx:${NGINX_VERSION}
COPY --from=build /usr/local/nginx /usr/local/nginx
