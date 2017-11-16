use strict;
use warnings;

use CHI                    ();
use PAUSE::Packages        ();
use WWW::Mechanize::Cached ();

my $cache = CHI->new(
    driver   => 'File',
    root_dir => '/tmp/mech-example'
);

my $mech = WWW::Mechanize::Cached->new( cache => $cache );

my $pp       = PAUSE::Packages->new;
my $iterator = $pp->release_iterator();

while ( my $release = $iterator->next_release ) {
    print 'path = ', $release->path, "\n";
    print '   modules = ',
        join( ', ', map { $_->name } @{ $release->modules } ), "\n";
    use DDP;
    p $release;
    p $release->distinfo;
    p $release->distinfo->dist;
    p $release->distinfo->distvname;
    p $release->modules;
    last;
}

