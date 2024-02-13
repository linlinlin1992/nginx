# Use alpine as base image
FROM alpine:latest

# Define who maintains this Dockerfile
LABEL maintainer="Your Name"

# Install dependencies
RUN apk add --no-cache \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg1 \
  libxslt-dev \
  gd-dev \
  geoip-dev

# Define ENVs
ENV NGINX_VERSION 1.21.0

# Get Nginx source
WORKDIR /tmp
RUN wget "http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz" && \
    tar -zxf "nginx-$NGINX_VERSION.tar.gz" && \
    rm -rf nginx-$NGINX_VERSION.tar.gz

# Configure Nginx with the modules
WORKDIR /tmp/nginx-$NGINX_VERSION
RUN ./configure --with-stream --with-stream_ssl_preread_module --with-http_ssl_module --with-http_v2_module --with-http_realip_module && \
    make && make install

# Clean up
RUN apk del \
  gcc \
  libc-dev \
  make \
  openssl-dev \
  pcre-dev \
  zlib-dev \
  linux-headers \
  curl \
  gnupg1 && \
  rm -rf /var/cache/apk/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80

# Define the running command
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
