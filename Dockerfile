# VERSION 1.0
# AUTHOR:         Jerome Guibert <jguibert@gmail.com>
# DESCRIPTION:    Redis Dockerfile
# TO_BUILD:       docker build --rm -t airdock/redis .
# SOURCE:         https://github.com/airdock-io/docker-redis

# Pull base image.
FROM airdock/base:latest

MAINTAINER Jerome Guibert <jguibert@gmail.com>

# Install redis server
# Run in foreground, listen on all addresses
RUN echo "deb http://http.debian.net/debian wheezy-backports main contrib non-free" > /etc/apt/sources.list.d/backports.list && \
    apt-get update -qq && \
    apt-get install --no-install-recommends -y -t wheezy-backports redis-server && \
    sed -i 's/^\(daemonize\s*\)yes\s*$/\1no/g' /etc/redis/redis.conf && \
    sed -ri 's/^bind .*$/bind 0.0.0.0/g' /etc/redis/redis.conf && \
    sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && \
    /root/post-install

# Data Folder
VOLUME ["/var/lib/redis"]

# Expose ports.
EXPOSE 6379

# Define default command.
CMD ["gosu", "redis:redis", "/usr/bin/redis-server", "/etc/redis/redis.conf"]
