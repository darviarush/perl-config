use common::sense; use open qw/:std :utf8/; use Test::More 0.98; use Carp::Always::Color; sub _mkpath_ { my ($p) = @_; length($`) && !-e $`? mkdir($`, 0755) || die "mkdir $`: $!": () while $p =~ m!/!g; $p } BEGIN { my $t = `pwd`; chop $t; $t .= '/' . __FILE__; my $s = '/tmp/.liveman/perl-config/config/'; `rm -fr $s` if -e $s; chdir _mkpath_($s) or die "chdir $s: $!"; open my $__f__, "<:utf8", $t or die "Read $t: $!"; $s = join "", <$__f__>; close $__f__; while($s =~ /^#\@> (.*)\n((#>> .*\n)*)#\@< EOF\n/gm) { my ($file, $code) = ($1, $2); $code =~ s/^#>> //mg; open my $__f__, ">:utf8", _mkpath_($file) or die "Write $file: $!"; print $__f__ $code; close $__f__; } } # # NAME
# 
# config - Perl module constant configurator
# 
# # VERSION
# 
# 1.0
# 
# # SYNOPSIS
# 
# File lib/My/Query.pm:
#@> lib/My/Query.pm
#>> package My::Query;
#>> 
#>> use config DB_NAME => "mizericordia";
#>> use config DB_HOST => "192.168.0.1";
#>> 
#>> use config {
#>>     DB_USER => "root",
#>>     DB_PASSWORD => "pass",
#>> };
#>> 
#>> our $connect = "mysql://" . DB_USER . ":" . DB_PASSWORD . "\@" . DB_HOST . "/" . DB_NAME;
#>> 
#>> 1;
#@< EOF
# 
# File .config.pm:
#@> .config.pm
#>> package config;
#>> 
#>> config_module 'My::Query' => {
#>>     DB_HOST => "mydb.com",
#>> };
#>> 
#>> 1;
#@< EOF
# 
# What happened:
subtest 'SYNOPSIS' => sub { 
use lib 'lib';
use My::Query;

::is scalar do {$My::Query::connect}, 'mysql://root:pass@mydb.com/mizericordia', '$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia';

# 
# # DESCRIPTION
# 
# Config make constant as `use constant`, but it values substitutes on values from local config if exists.
# 
# Local config is the **./.config.pm** in root folder of the project.
# 
# The project must start from this folder in order for the **./.config.pm** to be read.
# 
# # METHODS
# 
# ## import ($name, [$value])
# 
done_testing; }; subtest 'import ($name, [$value])' => sub { 
# One constant
use config A => 10;

# Multiconstants:
use config {
    B => 3,
    C => 4,
};

::is scalar do {A}, "10", 'A # => 10';
::is scalar do {B}, "3", 'B # => 3';
::is scalar do {C}, "4", 'C # => 4';

# And at runtime:
config->import('D' => 5);

::is scalar do {D()}, "5", 'D() # => 5';

# without params
use config;

# 
# ## config_module MODULE => {...}
# 
# Subroutine use in local config (**./.config.pm**) for configure perl module. To do this, the config must have `package config`.
# 
done_testing; }; subtest 'config_module MODULE => {...}' => sub { 
# config_module at runtime set only runtime constants
config::config_module 'main' => {
    D => 10,
    X => 12,
};

config->import('X' => 15);

::is scalar do {D()}, "5", 'D() # => 5';
::is scalar do {X()}, "12", 'X() # => 12';

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
# # AUTHOR
# 
# Yaroslav O. Kosmina [dart@cpan.org](mailto:dart@cpan.org)
# 
# # LICENSE
# 
# ⚖ **GPLv3**
	done_testing;
};

done_testing;
