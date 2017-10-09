FROM docker.io/arm32v7/busybox:latest

LABEL maintainer="Nick V<dcnickv@gmail.com>"

LABEL component="telegraf"
LABEL component_version="1.4.1"

COPY telegraf-1.4.1_linux_armhf.tar.gz /
COPY telegraf.conf /
COPY docker-entrypoint.sh /

RUN tar xzf /telegraf-1.4.1_linux_armhf.tar.gz -C / && \
    mv /telegraf.conf /telegraf/etc/telegraf.conf && \
    mkdir -p /telegraf/etc/telegraf.d && \
    adduser -u 901 -D -S telegraf && \
    chown -R telegraf: /telegraf && \
    chown -R telegraf: /docker-entrypoint.sh && \
    chmod 0500 /docker-entrypoint.sh

WORKDIR /telegraf

USER telegraf

ENTRYPOINT ["/docker-entrypoint.sh"]
# ENTRYPOINT ["/influxdb/usr/bin/influxd"]
# CMD ["run","-config","/influxdb/influxdb.conf","-pidfile","/var/run/influxdb.pid"]
