package config;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use constant {};

our %_CONFIG;

# Конфигурирует модуль. Должен использоваться в .config.pm
sub config_module {
	my ($pkg, $constants) = @_;
	$_CONFIG{$pkg} = $constants;
	return;
}

# Проект всегда старует от корня своей директории, где и должен лежать модуль
require "./.config.pm" if -e "./.config.pm";

# Импортирует конфиг-константы
sub import {
	my ($cls, $name, $value) = @_;
	return if !defined $name;
	my $hash = ref $name eq "HASH"? $name: +{($name => $value)};
	
	my $pkg = caller;

	constant->import("${pkg}::$_", exists $_CONFIG{$pkg} && exists $_CONFIG{$pkg}{$_}? $_CONFIG{$pkg}{$_}: $hash->{$_}) for keys %$hash;
}

1;




































































__END__

=encoding utf-8

=head1 NAME

B<config> — Perl module constant configurator.

=head1 SYNOPSIS

File lib/My/Query.pm:

	package My::Query;
	
	use config DB_NAME => "mizericordia";
	use config DB_HOST => "192.168.0.1";
	
	use config {
	    DB_USER => "root",
	    DB_PASSWORD => "pass",
	};
	
	our $connect = "mysql://" . DB_USER . ":" . DB_PASSWORD . "\@" . DB_HOST . "/" . DB_NAME;
	
	1;

File .config.pm:

	package config;
	
	config_module 'My::Query' => {
	    DB_HOST => "mydb.com",
	};
	
	1;

What happened:

	unshift @INC, "lib";
	require My::Query;
	
	$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia

=head1 DESCRIPTION

Config make constant as C<use constant>, but it values substitutes on values from local config if exists.

Local config is the B<./.config.pm> in root folder of the project.

The project must start from this folder in order for the B<./.config.pm> to be read.

=head2 METHODS

=head1 import

File lib/Example.pm:

	package Example;
	
	# One constant
	use config A => 10;
	
	# Multiconstants:
	use config {
	    B => 3,
	    C => 4,
	};
	
	1;



	require Example;
	
	Example::A() # => 10
	Example::B() # => 3
	Example::C() # => 4
	
	# And in runtime:
	config->import('D' => 5);
	
	D() # => 5

=head1 config_module MODULE => {...}

Subroutine use in local config (B<./.config.pm>) for configure perl module. To do this, the config must have C<package config>.

=head1 INSTALL

Add to B<cpanfile> in your project:

	on 'test' => sub {
		requires 'config', 
			git => 'https://github.com/darviarush/perl-config.git',
			ref => 'master',
		;
	};

And run command:

	$ sudo cpm install -gvv

=head1 LICENSE

⚖ B<GPLv3>

=head1 AUTHOR

Yaroslav O. Kosmina LL<mailto:dart@cpan.org>
