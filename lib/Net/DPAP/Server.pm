package Net::DPAP::Server;
use strict;
use warnings;
use Net::DPAP::Server::Image;
use File::Find::Rule;
use base qw( Net::DMAP::Server );
our $VERSION = '0.01';

sub protocol { 'dpap' }

sub default_port { 8770 }

sub find_tracks {
    my $self = shift;
    for my $file ( find name => "*.jpeg", in => $self->path ) {
        my $track = Net::DPAP::Server::Image->new_from_file( $file );
        $self->tracks->{ $track->dmap_itemid } = $track;
    }
}

sub server_info {
    my ($self, $request, $response) = @_;
    $response->content( $self->_dmap_pack(
        [[ 'dmap.serverinforesponse' => [
            [ 'dmap.status' => 200 ],
            [ 'dmap.protocolversion' => 2 ],
            [ 'dpap.protocolversion' => 1 ],
            [ 'dmap.itemname' => $self->name ],
            [ 'dmap.loginrequired' =>  0 ],
            [ 'dmap.timeoutinterval' => 0 ],
            [ 'dmap.supportsautologout' => 0 ],
            [ 'dmap.authenticationmethod' => 0 ],
            [ 'dmap.databasescount' => 1 ],
           ]]] ));
}

sub _always_answer {
    my $self = shift;
    return qw( dmap.itemid ) if $self->uri =~ /dpap.(thumb|hires)/;
    return ( $self->SUPER::_always_answer, 'dpap.imagefilename' );
}

1;
