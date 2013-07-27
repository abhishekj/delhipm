package DelhipmNew::View::Email;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::Email';
__PACKAGE__->config(
        'View::Email' => {
            stash_key => 'email',
            default => {
                # Defines the default content type (mime type). Mandatory
                content_type => 'text/plain',
                # Defines the default charset for every MIME part with the 
                # content type text.
                # According to RFC2049 a MIME part without a charset should
                # be treated as US-ASCII by the mail client.
                # If the charset is not set it won't be set for all MIME parts
                # without an overridden one.
                # Default: none
                charset => 'utf-8'
            },
            # Setup how to send the email
            # all those options are passed directly to Email::Sender::Simple
            sender => {
                # if mailer doesn't start with Email::Sender::Simple::Transport::,
                # then this is prepended.
                mailer => 'SMTP',
                # mailer_args is passed directly into Email::Sender::Simple 
               
          }
        }
    );

=head1 NAME

DelhipmNew::View::Email - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

user

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
