use strict;
use warnings;

use Test::More;
use JSON;
use Test::Deep;
use HTTP::Tiny;

my @paths = qw(
    /module/ISHIGAKI/Archive-Any-Lite-0.11/lib/Archive/Any/Lite.pm
    /module/OALDERS/ElasticSearchX-Model-1.0.0/lib/ElasticSearchX/Model/Bulk.pm
);

my $old_stub = 'https://api.metacpan.org/';
my $new_stub = 'https://api-v1.metacpan.org/';

for my $path (@paths) {
    my $old_res = HTTP::Tiny->new->get($old_stub . $path);
    my $new_res = HTTP::Tiny->new->get($new_stub . $path);

    my $old = decode_json($old_res->{content});
    my $new = decode_json($new_res->{content});

        # we know this is an extra field
    delete $new->{download_url};

        # and these won't match
    delete $new->{stat}->{gid};
    delete $old->{stat}->{gid};
    delete $new->{stat}->{uid};
    delete $old->{stat}->{uid};

    cmp_deeply(
      $new,
      $old,
      "$path matches"
    );

}

done_testing();
