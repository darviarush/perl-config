use common::sense; use open qw/:std :utf8/;  use Carp qw//; use File::Basename qw//; use File::Slurper qw//; use File::Spec qw//; use File::Path qw//; use Scalar::Util qw//;  use Test::More 0.98;  BEGIN {     $SIG{__DIE__} = sub {         my ($s) = @_;         if(ref $s) {             $s->{STACKTRACE} = Carp::longmess "?" if "HASH" eq Scalar::Util::reftype $s;             die $s;         } else {             die Carp::longmess defined($s)? $s: "undef"         }     };      my $t = File::Slurper::read_text(__FILE__);     my $s =  '/tmp/.liveman/perl-config/config'    ;     File::Path::rmtree($s) if -e $s;     File::Path::mkpath($s);     chdir $s or die "chdir $s: $!";      while($t =~ /^#\@> (.*)\n((#>> .*\n)*)#\@< EOF\n/gm) {         my ($file, $code) = ($1, $2);         $code =~ s/^#>> //mg;         File::Path::mkpath(File::Basename::dirname($file));         File::Slurper::write_text($file, $code);     }  } # 
# # NAME
# 
# config - Конфигуратор констант Perl-модуля
# 
# # VERSION
# 
# 1.3.0
# 
# # SYNOPSIS
# 
# Файл lib/My/Query.pm:
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
# Файл .config.pm:
#@> .config.pm
#>> package config;
#>> 
#>> config 'My::Query' => (
#>>     DB_HOST => "mydb.com",
#>> );
#>> 
#>> 1;
#@< EOF
# 
# Что должно получиться:
subtest 'SYNOPSIS' => sub { 
use lib 'lib';
use My::Query;

::is scalar do {$My::Query::connect}, 'mysql://root:pass@mydb.com/mizericordia', '$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia';

# 
# # DESCRIPTION
# 
# `use config` создаёт константу так же как `use constant`, но берёт значение из локального конфиг-файла проекта, если она там указана.
# 
# Файл конфига **./.config.pm** находится в корневой директории проекта.
# 
# Текущая директория в проекте должна соответствовать корню проекта.
# 
# # METHODS
# 
# ## import ($name, [$value])
# 
done_testing; }; subtest 'import ($name, [$value])' => sub { 
# Одна константа
use config A => 10;

# Много констант:
use config {
    B => 3,
    C => 4,
};

::is scalar do {A}, "10", 'A # => 10';
::is scalar do {B}, "3", 'B # => 3';
::is scalar do {C}, "4", 'C # => 4';

# И в рантайме:
config->import('D' => 5);

::is scalar do {D()}, "5", 'D() # => 5';

# Без параметров:
use config;

# 
# ## config MODULE => (...)
# 
# Функция используется в файле конфига (**./.config.pm**) для настройки модулей Perl. Для конфиг должен начинаться на `package config;`.
# 
done_testing; }; subtest 'config MODULE => (...)' => sub { 
config::config 'main' => (
    D => 10,
    X => 12,
);

config->import('X' => 15);

::is scalar do {D()}, "5", 'D() # => 5';
::is scalar do {X()}, "12", 'X() # => 12';

# 
# # AUTHOR
# 
# Yaroslav O. Kosmina <dart@cpan.org>
# 
# # LICENSE
# 
# ⚖ **Perl5**
# 
# # COPYRIGHT
# 
# The config module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.

	done_testing;
};

done_testing;
