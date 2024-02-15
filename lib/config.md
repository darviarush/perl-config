!ru:en
# NAME

config - Конфигуратор констант Perl-модуля

# VERSION

1.4.1

# SYNOPSIS

Файл lib/My/Query.pm:
```perl
package My::Query;

use config DB_NAME => "mizericordia";
use config DB_HOST => "192.168.0.1";

use config {
    DB_USER => "root",
    DB_PASSWORD => "pass",
};

our $connect = "mysql://" . DB_USER . ":" . DB_PASSWORD . "\@" . DB_HOST . "/" . DB_NAME;

1;
```

Файл .config.pm:
```perl
package config;

config 'My::Query' => (
    DB_HOST => "mydb.com",
);

1;
```

Что должно получиться:
```perl
use lib 'lib';
use My::Query;

$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia
```

# DESCRIPTION

`use config` создаёт константу так же как `use constant`, но берёт значение из локального конфиг-файла проекта, если она там указана.

Файл конфига **./.config.pm** находится в корневой директории проекта.

Текущая директория в проекте должна соответствовать корню проекта.

# METHODS

## import ($name, [$value])

```perl
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
```

## config MODULE => (...)

Функция используется в файле конфига (**./.config.pm**) для настройки модулей Perl. Для конфиг должен начинаться на `package config;`.

```perl
config::config 'main' => (
    D => 10,
    X => 12,
);

config->import('X' => 15);

D() # => 5
X() # => 12
```

# AUTHOR

Yaroslav O. Kosmina <dart@cpan.org>

# LICENSE

⚖ **Perl5**

# COPYRIGHT

The config module is copyright © 2023 Yaroslav O. Kosmina. Rusland. All rights reserved.