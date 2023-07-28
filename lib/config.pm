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
require "./.config.pm";

# Импортирует конфиг-константы
sub import {
	my ($cls, $name, $value) = @_;
	my $hash = ref $name eq "HASH"? $name: {$name => $value};
	
	my $pkg = caller;

	constant->import("${pkg}::$_", exists $_CONFIG{$pkg} && exists $_CONFIG{$pkg}{$_}? $_CONFIG{$pkg}{$_}: $hash->{$_}) for keys %$hash;
}

1;
__END__

=encoding utf-8

=head1 NAME

config - It's new $module

=head1 SYNOPSIS

	package Query {
		use config DB_NAME => "mizericordia";
		
		...
	}

=head1 DESCRIPTION

main_config is ...

=head1 LICENSE

Copyright (C) Yaroslav O. Kosmina.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Yaroslav O. Kosmina E<lt>darviarush@mail.ruE<gt>

=cut

