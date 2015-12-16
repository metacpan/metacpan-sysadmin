#!/bin/sh

sudo -u metacpan /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan release --latest $@
