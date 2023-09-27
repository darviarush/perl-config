package config;
use 5.008001;
use strict;
use warnings;

our $VERSION = "1.2";

use constant {};

our %_CONFIG;

# Конфигурирует модуль. Должен использоваться в .config.pm
sub config_module($$) {
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

	if(!$^V or $^V lt 5.22.0) {
		no strict 'refs';
		for(keys %$hash) {
			my $val = exists $_CONFIG{$pkg} && exists $_CONFIG{$pkg}{$_}? $_CONFIG{$pkg}{$_}: $hash->{$_};
			*{"${pkg}::$_"} = sub {$val};
		}
	} else {
		constant->import("${pkg}::$_", exists $_CONFIG{$pkg} && exists $_CONFIG{$pkg}{$_}? $_CONFIG{$pkg}{$_}: $hash->{$_}) for keys %$hash;
	}

}

1;

__END__

=encoding utf-8

=head1 NAME

config - Perl module constant configurator

=head1 VERSION

1.2

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

	use lib 'lib';
	use My::Query;
	
	$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia

=head1 DESCRIPTION

Config make constant as C<use constant>, but it values substitutes on values from local config if exists.

Local config is the B<./.config.pm> in root folder of the project.

The project must start from this folder in order for the B<./.config.pm> to be read.

=head1 METHODS

=head2 import ($name, [$value])

	# One constant
	use config A => 10;
	
	# Multiconstants:
	use config {
	    B => 3,
	    C => 4,
	};
	
	A # => 10
	B # => 3
	C # => 4
	
	# And at runtime:
	config->import('D' => 5);
	
	D() # => 5
	
	# without params
	use config;

=head2 config_module MODULE => {...}

Subroutine use in local config (B<./.config.pm>) for configure perl module. To do this, the config must have C<package config>.

	# config_module at runtime set only runtime constants
	config::config_module 'main' => {
	    D => 10,
	    X => 12,
	};
	
	config->import('X' => 15);
	
	D() # => 5
	X() # => 12

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

=head1 AUTHOR

Yaroslav O. Kosmina LL<mailto:dart@cpan.org>

=head1 LICENSE

⚖ B<GPLv3>
