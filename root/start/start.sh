#!/usr/bin/env bash
set -e

mkdir -pm 0777 /app/logs

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf