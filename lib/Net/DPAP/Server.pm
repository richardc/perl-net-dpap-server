use strict;
package Net::DPAP::Server;
use Net::DMAP::Server;
use base qw( Net::DMAP::Server );
use Net::DPAP::Server::Image;
use File::Find::Rule;

sub protocol { 'dpap' }

sub find_tracks {
    my $self = shift;
    for my $file ( find name => "*.jpeg", in => $self->path ) {
        my $track = Net::DPAP::Server::Image->new_from_file( $file );
        $self->tracks->{ $track->dmap_itemid } = $track;
    }
}


sub server_info {
    my $self = shift;
    $self->_dmap_response( [[ 'dmap.serverinforesponse' => [
        [ 'dmap.status' => 200 ],
        [ 'dmap.protocolversion' => 2 ],
        [ 'dpap.protocolversion' => 1 ],
        [ 'dmap.itemname' => ref $self ],
        [ 'dmap.loginrequired' =>  0 ],
        [ 'dmap.timeoutinterval' => 0 ],
        [ 'dmap.supportsautologout' => 0 ],
        [ 'dmap.authenticationmethod' => 0 ],
        [ 'dmap.databasescount' => 1 ],
       ]]] );
}

sub always_answer {
    my $self = shift;
    return qw( dmap.itemid ) if $self->uri =~ /dpap.(thumb|hires)/;
    return ( $self->SUPER::always_answer, 'dpap.imagefilename' );
}

1;
