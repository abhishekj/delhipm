package DelhipmNew;
use Moose;
use namespace::autoclean;
use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple    
    Authentication
    Session
    Session::Store::FastMmap
    Session::State::Cookie    
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in delhipmnew.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'DelhipmNew',
    default_view	=>'DelhipmNew',
    'Plugin::Session' => {
    	flash_to_stash=>'1',
    },
'Plugin::Authentication' => {
            default => {
            	 credential => {
                            class => 'Password',                  
                            password_field => 'password',
                            password_type => 'clear',
                        },
                  store => {
                            class => 'DBIx::Class',
                            user_model      => 'DB::Member',
                  }
            },
        },
         static => {
            dirs => [
                'static',
                qr/^(images|css|js|img|fonts)/,
            ],
        },
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    default_view	=>'TT',
);
sub redirect_to_action {
    my ($c, $controller, $action, @params) =@_;
    $c->response->redirect($c->uri_for($c->controller($controller)->action_for($action), @params));
    $c->detach;
}
    

# Start the application
__PACKAGE__->setup();


=head1 NAME

DelhipmNew - Catalyst based application

=head1 SYNOPSIS

    script/delhipmnew_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<DelhipmNew::Controller::Root>, L<Catalyst>

=head1 AUTHOR
AJ
=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
