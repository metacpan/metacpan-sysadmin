#!/bin/sh

# sh reindex-perl.sh https://cpan.metacpan.org/authors/id/R/RJ/RJBS/perl-5.22.0.tar.bz2 https://cpan.metacpan.org/authors/id/S/SH/SHAY/perl-5.22.1.tar.gz

sudo -u metacpan /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan release $1 --status cpan
sudo -u metacpan /home/metacpan/bin/metacpan-api-carton-exec bin/metacpan release --status latest $2
