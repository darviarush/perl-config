use strict; use warnings; use utf8; use open qw/:std :utf8/; use Test::More 0.98; use Carp::Always::Color; sub _mkpath_ { my ($p) = @_; length($`) && !-e $`? mkdir($`, 0755) || die "mkdir $`: $!": () while $p =~ m!/!g; $p } BEGIN { my $s = '/tmp/.liveman/perl-config/config/'; `rm -fr $s` if -e $s; chdir _mkpath_($s) or die "chdir $s: $!" } # # NAME
# 
# **config** — Perl module constant configurator.
# 
# # SYNOPSIS
# 
# File lib/My/Query.pm:

{ my $s = main::_mkpath_('lib/My/Query.pm'); open my $__f__, '>:utf8', $s or die "Read $s: $!"; print $__f__ 'package My::Query;

use config DB_NAME => "mizericordia";
use config DB_HOST => "192.168.0.1";

use config {
    DB_USER => "root",
    DB_PASSWORD => "pass",
};

our $connect = "mysql://" . DB_USER . ":" . DB_PASSWORD . "\@" . DB_HOST . "/" . DB_NAME;

1;
'; close $__f__ }
# 
# File .config.pm:

{ my $s = main::_mkpath_('.config.pm'); open my $__f__, '>:utf8', $s or die "Read $s: $!"; print $__f__ 'package config;

config_module \'My::Query\' => {
    DB_HOST => "mydb.com",
};

1;
'; close $__f__ }
# 
# What happened:
subtest 'SYNOPSIS' => sub { 
unshift @INC, "lib";
require My::Query;

is scalar do {$My::Query::connect}, 'mysql://root:pass@mydb.com/mizericordia', '$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia';

# 
# # DESCRIPTION
# 
# Config make constant as `use constant`, but it values substitutes on values from local config if exists.
# 
# Local config is the **./.config.pm** in root folder of the project.
# 
# The project must start from this folder in order for the **./.config.pm** to be read.
# 
# ## METHODS
# 
# # import
# 
# File lib/Example.pm:

{ my $s = main::_mkpath_('lib/Example.pm'); open my $__f__, '>:utf8', $s or die "Read $s: $!"; print $__f__ 'package Example;

# One constant
use config A => 10;

# Multiconstants:
use config {
    B => 3,
    C => 4,
};

1;
'; close $__f__ }
# 
done_testing; }; subtest 'import' => sub { 
require Example;

is scalar do {Example::A()}, "10", 'Example::A() # => 10';
is scalar do {Example::B()}, "3", 'Example::B() # => 3';
is scalar do {Example::C()}, "4", 'Example::C() # => 4';

# And in runtime:
config->import('D' => 5);

is scalar do {D()}, "5", 'D() # => 5';

# 
# # config_module MODULE => {...}
# 
# Subroutine use in local config (**./.config.pm**) for configure perl module. To do this, the config must have `package config`.
# 
# # INSTALL
# 
# Add to **cpanfile** in your project:
# 

# on 'test' => sub {
# 	requires 'config', 
# 		git => 'https://github.com/darviarush/perl-config.git',
# 		ref => 'master',
# 	;
# };

# 
# And run command:
# 

# $ sudo cpm install -gvv

# 
# # LICENSE
# 
# ⚖ **GPLv3**
# 
# # AUTHOR
# 
# Yaroslav O. Kosmina [dart@cpan.org](mailto:dart@cpan.org)
	done_testing;
};

done_testing;
