package DelhipmNew::Controller::Delhi;
use Moose;
use namespace::autoclean;

#BEGIN { extends 'Catalyst::Controller'; }
BEGIN {extends 'Catalyst::Controller::HTML::FormFu'; }

=head1 NAME

DelhipmNew::Controller::Delhi - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path : Args(0) {
	my ( $self, $c ) = @_;
}

#sub members : Path('members') : Args(0) {
#	my ( $self, $c, $member ) = @_;
#	$c->stash->{'list'} =
#	  [ $c->model('DB::Member')
#		  ->search( { 'active' => 'checked' }, { order_by => 'membername' } )
#		  ->all ];
#	$c->stash->{'template'} = 'members.tt';
#	$c->detach();

#}

sub members : Path('members') {
	my ( $self, $c, $member ) = @_;
	if($member){
	$c->stash->{'member'} =
	  $c->model('DB::Member')
	  ->find( { 'urlcomponent' => $member, 'active' => 'checked' },
		{ order_by => 'membername' } );
	if ( !$c->stash->{'member'} ) {
#		$c->response->redirect( $c->uri_for('/delhi/members/') );
		    $c->redirect_to_action('Delhi', 'members', []);
	}
	else {
		$c->stash->{'template'} = 'delhi/member.tt';
	}
	$c->detach();
	}else{
	$c->stash->{'list'} =
	  [ $c->model('DB::Member')
		  ->search( { 'active' => 'checked' }, { order_by => 'membername' } )
		  ->all ];
#	$c->stash->{'template'} = 'members.tt';
#	$c->detach();
		
	}
}

sub desc : Path('desc') : Args(1) {

	my ( $self, $c, $jobid ) = @_;
	if ($jobid) {
		$c->stash->{'job'} =
		  $c->model('DB::job')->find( { 'jobid' => $jobid } );

	}

}

sub join : Local : Args(0) : FormConfig {
	my ( $self, $c ) = @_;
	my $form = $c->stash->{form};
	my $member_exists =
	  $c->model('DB::Member')
	  ->find( { 'urlcomponent' => $c->request->params->{'urlcomponent'} } );
	if ( $form->submitted_and_valid ) {
		if ( !$member_exists ) {
			if ( !$c->model('DB::Member')
				->find( { 'email' => $c->request->params->{'email'} } ) )
			{
				my $member = $c->model('DB::Member')->create(
					{
						urlcomponent => $c->request->params->{'urlcomponent'},
						membername   => $c->request->params->{'membername'},
						id           => $c->request->params->{'id'},
						email        => $c->request->params->{'email'},
						password     => $c->request->params->{'password'},
						description  => $c->request->params->{'description'},
						lastsigned   => \"NOW()"

					}
				);

				if (
					$c->authenticate(
						{
							membername => $c->request->params->{'membername'},
							password   => $c->request->params->{'password'}
						}
					)
				  )
				{
					$c->stash->{email} = {
						to      => $c->req->param('email'),
						from    => 'delhi-pm-owner@pm.org',
						subject => 'Welcome Delhi-pm.org',
						body =>
'Thanking for joining and if you want to be a part of Delhipm.org subscribing list visit this link <a href="http://mail.pm.org/mailman/listinfo/delhi-pm">http://mail.pm.org/mailman/listinfo/delhi-pm</a>'
					};
					$c->forward( $c->view('Email') );
				}

				$c->response->redirect(
					$c->uri_for(
						'/members/' . $c->request->params->{'urlcomponent'}
					)
				);
				$c->detach;
			}
			else {
				$c->stash( error_message => 'Email already Exists!' );
			}
		}
		else {
			$c->stash( error_message => 'Login name already Exists!' );
		}
	}
#	$c->stash( template => 'join.tt' );

#	$c->detach;

}

sub meetup : Local:Args(0) {

	my ( $self, $c ) = @_;
	$c->stash( meetups  => [ $c->model('DB::meetup')->all ] );

}

sub jobboard : Local: Args(0) {
	my ( $self, $c ) = @_;
	$c->stash(
		jobs => [
			$c->model('DB::job')->search( {}, { order_by => 'jobid DESC' } )
			  ->all
		]
	);

}

sub mailinglist : Local:Args(0) {
	my ( $self, $c ) = @_;
}

sub postjob : Local : Args(0) : FormConfig {

	my ( $self, $c ) = @_;

	if ( $c->user_exists() ) {
		my $form = $c->stash->{form};
		if ( $form->submitted_and_valid ) {
			my $jobs = $c->model('DB::Job')->create(
				{
					companyname => $c->request->params->{'companyname'},
					title       => $c->request->params->{'title'},
					type        => $c->request->params->{'type'},
					email       => $c->request->params->{'email'},
					description => $c->request->params->{'description'},

				}
			);

			{
#				$c->response->redirect( $c->uri_for('/jobboard') );
				    $c->redirect_to_action('Delhi', 'jobboard', []);
			}
		}

		$c->stash( template => 'delhi/jobs.tt' );
		$c->detach;

	}
	else {
    	$c->redirect_to_action('Delhi', 'login', []);
	}

}

sub login : Local : Args(0) : FormConfig {
	my ( $self, $c ) = @_;
	my $form     = $c->stash->{form};
	my $username = $c->request->params->{username};
	my $password = $c->request->params->{password};
	if ( $form->submitted_and_valid ) {
		if ( $username && $password ) {

			if (
				$c->authenticate(
					{
						urlcomponent => $username,
						password     => $password
					}
				)
			  )
			{
				if ( $c->model('DB::Member')
					->search( { urlcomponent => $username } ) )
				{
					$c->model('DB::Member')
					  ->search( { urlcomponent => $username } )
					  ->update( { lastsigned => \"now()" } );
					$c->response->redirect( $c->uri_for('/members') );
				}
				$c->detach;
			}
			else {

				$c->stash( error_message => "Bad username or password." );
			}
		}
		else {

			$c->stash( error_message => "Empty username or password." );
		}

	}

}

sub logout : Local: Args(0) {
	my ( $self, $c ) = @_;
	$c->logout();
	$c->response->redirect( $c->uri_for('/') );
}

=head1 AUTHOR

user

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
