use strict;
use warnings;
use Data::Dumper;
use Search::Elasticsearch;

my $remove = ( shift ? 1 : 0 );

my $es = Search::Elasticsearch->new(
    nodes => [ "localhost:9200" ],
);

my $sc_ids = $es->scroll_helper(
    index       => 'cpan',
    type        => 'release',
    search_type => 'scan',
    size        => 500,
    body        => {
        query => {
            filtered => {
                query  => { match_all => {} },
                filter => {
                    and => {
                        filters => [
                            { term    => { authorized => 0        } },
                            { missing => { field      => "author" } }
                        ]
                    }
                }
            }
        },
        fields => ['id'],
    }
);

my $bulk = $es->bulk_helper(
    index => 'cpan',
    type  => 'release',
);

my @ids;
while ( my $r = $sc_ids->next ) {
    push @ids => $r->{fields}{id}[0];
}

if ( $remove ) {
    $bulk->delete_ids( @ids );
    $bulk->flush;
} else {
    print Dumper \@ids;
}

1;
