package Net::DPAP::Server::Image;
use strict;
use warnings;
use base qw( Class::Accessor::Fast );
use File::Basename qw( basename );
use Image::Info;
use Perl6::Slurp;

__PACKAGE__->mk_accessors(qw(
      file
      dmap_itemid dmap_itemname dmap_itemkind dmap_containeritemid

      dpap_imagefilename dpap_aspectratio dpap_imagefilesize dpap_creationdate
));

sub new_from_file {
    my $class = shift;
    my $file = shift;
    my $self = $class->new({ file => $file });
    print "Adding $file\n";

    my @stat = stat $file;
    my $info = Image::Info::image_info( $file );
    $self->file( $file );
    $self->dmap_itemid( $stat[1] ); # the inode should be good enough
    $self->dmap_containeritemid( 0+$self );

    $self->dpap_imagefilename( basename $file );
    $self->dpap_aspectratio( $info->{width} / $info->{height} );
    $self->dpap_imagefilesize( $stat[7] );
    $self->dpap_creationdate( $stat[10] );
    $self->dmap_itemname( basename $file, qw( .jpeg .jpg ) );
    $self->dmap_itemkind( 3 );

    return $self;
}

sub dpap_hires {
    my $self = shift;
    scalar slurp $self->file;
}


# A thumbnail should be smaller 240x180 72dpi jpeg

sub dpap_thumb {
    my $self = shift;
    scalar slurp $self->file;
}


1;
