package config;
use 5.008001;
use strict;
use warnings;

our $VERSION = "1.3.0";

use constant {};

our %_CONFIG;

# Конфигурирует модуль. Должен использоваться в .config.pm
sub config($%) {
	my $pkg = shift;
	$_CONFIG{$pkg} = {@_};
	return;
}

# Конфигурирует модуль. Должен использоваться в .config.pm
#@deprecated
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

1.3.0

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

.config.pm file:

	package config;
	
	config 'My::Query' => (
	    DB_HOST => "mydb.com",
	);
	
	1;

What should happen:

	use lib 'lib';
	use My::Query;
	
	$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia

=head1 DESCRIPTION

C<use config> creates a constant in the same way as C<use constant>, but takes the value from the project's local config file if one is specified there.

The config file B<./.config.pm> is located in the root directory of the project.

The current directory in the project must correspond to the project root.

=head1 METHODS

=head2 import ($name, [$value])

	# Одна константа
	use config A => 10;
	
	# Много констант:
	use config {
	    B => 3,
	    C => 4,
	};
	
	A # => 10
	B # => 3
	C # => 4
	
	# И в рантайме:
	config->import('D' => 5);
	
	D() # => 5
	
	# Без параметров:
	use config;

=head2 config MODULE => (...)

The function is used in the config file (B<./.config.pm>) to configure Perl modules. For config it should start with C<package config;>.

	config::config 'main' => (
	    D => 10,
	    X => 12,
	);
	
	config->import('X' => 15);
	
	D() # => 5
	X() # => 12

=head1 AUTHOR

Yaroslav O. Kosmina L<mailto:dart@cpan.org>

=head1 LICENSE

⚖ B<Perl5>

=head1 COPYRIGHT

The config module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.
