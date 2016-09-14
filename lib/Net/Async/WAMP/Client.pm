# ABSTRACT: WebSocket client module for Net::Async::WAMP.
package Net::Async::WAMP::Client;

use strict;
use warnings;

use JSON;
use Net::Async::WebSocket::Client;
use IO::Async::Loop;
#use IO::Async::Test;
use Data::Dumper;

sub new {
    my ($class,$args)=@_;
    my $self={};
    $self->{clientframes}=();
    $self->{loop} = IO::Async::Loop->new();
    #testing_loop($self->{loop});
    $self->{client} = Net::Async::WebSocket::Client->new(
        on_frame => sub {
            my ( $self, $frame ) = @_;
            print STDERR "receive by client: ".Dumper($frame)."\n";
            push @{$self->{clientframes}}, $frame;
            #print "clientframes: ".Dumper(@{$self->{clientframes}})."\n";
        },
    );
    $self->{loop}->add($self->{client});
    $self->{connected}=undef;
    return bless $self, $class;
}

sub connect {
    my ($self,$args)=@_;
    $self->{client}->connect(
        host             => $args->{host},
        service          => $args->{port},
        url              => $args->{url},
        on_connected     => sub { $self->{connected}++ },
        on_resolve_error => sub { die "Test failed early - $_[-1]" },
        on_connect_error => sub { die "Test failed early - $_[-1]" },
    );
    print "wait_for connected\n";
    #wait_for { $self->{connected} };
}

sub wait_welcome {
    my ($self)=@_;
    print "wait_for clientframes\n";
    #wait_for { @\{$self->{clientframes}} };
#is_deeply( \@clientframes, [$welcome_msg_json],
    
}

1;
