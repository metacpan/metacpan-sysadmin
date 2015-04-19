#!/bin/sh

sudo awk '{print $1}' /var/log/nginx/metacpan-api/access.log | sort | uniq -c | sort -nr | less
