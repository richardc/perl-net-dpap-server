package Net::DPAP::Server::Image;
use strict;
use warnings;
use base qw( Class::Accessor::Fast );
use Image::Info;

__PACKAGE__->mk_accessors(qw(
      file
      dmap_itemid dmap_itemname dmap_itemkind dmap_containeritemid

      dpap_aspectratio dpap_imagefilesize dpap_creationdate
));

sub new_from_file {
    my $class = shift;
    my $file = shift;
    my $self = $class->new({ file => $file });
    print "Adding $file\n";

    my @stat = stat $file;
    my $info = Image::Info::image_info( $file );
    $self->dmap_itemid( $stat[1] ); # the inode should be good enough
    $self->dmap_containeritemid( 0+$self );
    $self->dpap_aspectratio( $info->{width} / $info->{height} );
    $self->dpap_imagefilesize( $stat[7] );
    $self->dpap_creationdate( $stat[10] );
    $self->dmap_itemname( $file );
    $self->dmap_itemkind( 3 );

    return $self;
}

1;
