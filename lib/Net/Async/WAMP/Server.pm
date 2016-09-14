# ABSTRACT: WebSocket server module for Net::Async::WAMP.
package Net::Async::WAMP::Server;

use strict;
use warnings;

use JSON;
use Net::Async::WebSocket::Server;
use Net::Async::WAMP::Protocol;

sub new {
    my ($class,$args)=@_;
    my $self={};
    $self->{loop} = IO::Async::Loop->new();

    $self->{serversock} = IO::Socket::INET->new(
        LocalHost => '127.0.0.1',
        Listen    => 1,
    ) or die "Cannot allocate listening socket - $@";
    
    $self->{serverframes}=();
    $self->{acceptedclient}=undef;
    $self->{server} = Net::Async::WebSocket::Server->new(
        handle    => $self->{serversock},
        on_client => sub {
            my ( undef, $thisclient ) = @_;
            $self->{acceptedclient} = $thisclient;
            $thisclient->configure(
                on_frame => sub {
                    my ( $self, $frame ) = @_;
                    #print "receive by server: ".Dumper($frame)."\n";
                    push @{$self->{serverframes}}, $frame;
                },
            );
        },
    );
    $self->{loop}->add($self->{server});
    return bless $self, $class;
}

sub send_welcome {
    my ($self)=@_;
    $self->{acceptedclient}->send_frame(encode_json([
	Net::Async::WAMP::Protocol::TYPE_ID_WELCOME,
	Data::UUID->new()->create_str(),	
	1,
	'01_client_handshake'
    ]));
}

sub get_host {
    my ($self)=@_;
    return $self->{serversock}->sockhost;
}

sub get_port {
    my ($self)=@_;
    return $self->{serversock}->sockport;
}

1;
