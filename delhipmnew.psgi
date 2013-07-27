use strict;
use warnings;

use DelhipmNew;

my $app = DelhipmNew->apply_default_middlewares(DelhipmNew->psgi_app);
$app;

