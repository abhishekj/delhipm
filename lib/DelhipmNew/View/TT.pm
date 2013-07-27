package DelhipmNew::View::TT;

use strict;
use warnings;

use base 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    INCLUDE_PATH       => [
        DelhipmNew->path_to( 'root', 'src' )
    ],
    ENCODING => 'utf8',
    WRAPPER  => 'delhi/wrapper.tt',
    render_die => 1,
    
);

=head1 NAME

DelhipmNew::View::TT - TT View for DelhipmNew

=head1 DESCRIPTION

TT View for DelhipmNew.

=head1 SEE ALSO

L<DelhipmNew>

=head1 AUTHOR

user

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
