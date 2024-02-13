# Define the base image
FROM debian:stretch

# Define who maintains the Dockerfile
MAINTAINER Your Name

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    wget \
    build-essential \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    libssl-dev

# Define ENVs
ENV NGINX_VERSION=1.25.3

# Get Nginx source
WORKDIR /tmp
RUN wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
    tar -xf nginx-$NGINX_VERSION.tar.gz && \
    rm -rf nginx-$NGINX_VERSION.tar.gz

# Configure Nginx with the specific modules
WORKDIR /tmp/nginx-$NGINX_VERSION
RUN ./configure --with-stream --with-stream_ssl_preread_module --with-http_ssl_module --with-http_v2_module --with-http_realip_module && \
    make && make install

# Clean up
RUN apt-get remove --auto-remove -y \
    wget \
    build-essential \
    libpcre3-dev zlib1g-dev libssl-dev && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports
EXPOSE 80

# Define the running command
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
