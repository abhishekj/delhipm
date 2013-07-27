use strict;
use warnings;
use Test::More;


use Catalyst::Test 'DelhipmNew';
use DelhipmNew::Controller::Delhi;

ok( request('/delhi')->is_success, 'Request should succeed' );
done_testing();
