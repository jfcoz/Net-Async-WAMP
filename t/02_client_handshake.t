#!/usr/bin/env perl
#--[Modules.]-------------------------------------------------------------------
# Core.
use strict;
use warnings;
use Test::More;

# CPAN.
use Data::UUID;
use IO::Async::Loop;
use IO::Async::Test;
use IO::Socket::INET;
use JSON;

# Distribution.
use Net::Async::WAMP::Client;
use Net::Async::WAMP::Server;
#use Net::Async::WAMP::Protocol;

#--[Test execution.]------------------------------------------------------------
#testing_loop($loop);

my $server = Net::Async::WAMP::Server->new();
my $client = Net::Async::WAMP::Client->new();
$client->connect({
    host             => $server->get_host,
    port             => $server->get_port,
    url              => 'ws://localhost/test',
});

$server->send_welcome();
$client->wait_welcome();


#    'received WAMP WELCOME message' );

TODO: {
    local $TODO = 'Need to implement client handshake.';
}

# $client->send_frame('Here is my message');
# wait_for { @serverframes };
# is_deeply( \@serverframes, ['Here is my message'], 'received @serverframes' );

done_testing();
