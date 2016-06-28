use strict;
use warnings;

use Term::ANSIColor;
use MetaCPAN::Client;

my %domain = (
    V0 => 'api.metacpan.org',
    V1 => 'fastapi.metacpan.org',
);

my %results;

for my $ver ( qw< V0 V1 > ) {
    my $mcpan = MetaCPAN::Client->new( domain  => $domain{$ver}, version => lc($ver) );
    for my $type ( qw< files releases > ) {
        my $scroller = $mcpan->all( $type, get_filter_facets($ver) );
        $results{$type}{$ver} = (
            $ver eq 'V0'
            ? +{ map { $_->{term} => $_->{count}     } @{ $scroller->facets->{count}{terms}         } }
            : +{ map { $_->{key}  => $_->{doc_count} } @{ $scroller->aggregations->{count}{buckets} } }
        );
    }
}

my $line = "%-20s %-20s %-20s\n";
printf $line, map { yellow($_) } '', qw< V0 V1 >;
for my $type ( qw< files releases > ) {
    print green(uc($type)), "\n";
    for my $key ( qw< backpan cpan latest > ) {
        printf $line, white($key), map { blue( $results{$type}{$_}{$key} ) } qw< V0 V1 >;
    }
    print "\n";
}

1;

#################

sub yellow { colored($_[0], "bold yellow" ) }
sub white  { colored($_[0], "bold white"  ) }
sub blue   { colored($_[0], "bold bright_blue" ) }
sub green  { colored($_[0], "bold underline green" ) }

sub get_filter_facets {
    my $ver = shift;
    my $key = $ver eq 'V0' ? 'facets' : 'aggregations';
    return +{ $key => { count => { terms => { field => "status" } } } };
}

1;
