#!/bin/sh

sudo awk -F"\"" '{print $6}' /var/log/nginx/metacpan-web/access.log | sort | uniq -dc | sort -nr | head -20
