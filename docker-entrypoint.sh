#!/bin/sh

exec \
    /telegraf/usr/bin/telegraf \
    --config /telegraf/etc/telegraf.conf \
    --config-directory /telegraf/etc/telegraf.d/
