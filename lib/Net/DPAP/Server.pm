use strict;
package Net::DPAP::Server;
use base qw( Net::DAAP::Server );

sub server_info {
    my $self = shift;
    $self->_dmap_response( [[ 'dmap.serverinforesponse' => [
        [ 'dmap.status' => 200 ],
        [ 'dmap.protocolversion' => 2 ],
        [ 'dpap.protocolversion' => 1 ],
        [ 'dmap.itemname' => __PACKAGE__ ],
        [ 'dmap.loginrequired' =>  0 ],
        [ 'dmap.timeoutinterval' => 0 ],
        [ 'dmap.supportsautologout' => 0 ],
        [ 'dmap.authenticationmethod' => 0 ],
        [ 'dmap.databasescount' => 1 ],
       ]]] );
}

1;
