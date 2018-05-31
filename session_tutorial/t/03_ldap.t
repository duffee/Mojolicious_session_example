use Mojo::Base -strict;

use Test::More;
use Test::Mojo;
use Test::Net::LDAP::Util qw/ldap_mockify/;

my $t = Test::Mojo->new('SessionTutorial');

use YAML qw/LoadFile/;
my $config_file = 'ldap_config.sample.yml';
my $config = LoadFile($config_file);
my ($LDAP_server, $base_DN, $user_attr, $user_id, )
        = @{$config}{ qw/server baseDN username id/ };

# is the secure page protected?
ldap_mockify {
	# mock an LDAP server
	my $ldap = Net::LDAP->new($LDAP_server);
     
    $ldap->add("uid=deadauthor,$base_DN", attrs => [ userid => 'julian' ]);
    $ldap->add("uid=villain,$base_DN", attrs => [ userid => 'francisco']);
    $ldap->mock_bind(sub {
		my $arg = shift;
		if ($arg->{dn}->dn() eq "uid=deadauthor,$base_DN" 
			&& $arg->{password} eq 'carax') {
			return Net::LDAP::Constant::LDAP_SUCCESS;
		}
		else { return Net::LDAP::Constant::LDAP_INVALID_CREDENTIALS; }
	} );

	# test code
	$t->post_ok('/login' => {Accept => '*/*'} 
				=> form => {username => 'francisco', password => 'fumero'})
  		->status_is(403);

	$t->get_ok('/secure/protected')
		->status_is(401, 'Protected page is inaccessible without correct login');

	$t->get_ok('/login')->status_is(200)->content_like(qr/Username/i);

	# successful login and redirected (HTTP code 302) to Welcome page
	$t->post_ok('/login' => {Accept => '*/*'} 
				=> form => {username => 'julian', password => 'carax'})
  		->status_is(302)				
  		->content_like(qr/Welcome, julian/i);

	# protected page now accessible
	$t->get_ok('/secure/protected')
		->status_is(200)
		->content_like(qr/This is a protected page/);

};

done_testing();
