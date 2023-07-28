# NAME

**config** — Perl module constant configurator.

# SYNOPSIS

File lib/Query.pm:
```perl
package Query;

use config DB_NAME => "mizericordia";
use config DB_HOST => "192.168.0.1";

use config {
    DB_USER => "root",
    DB_PASSWORD => "pass",
};

our $connect = "mysql://" . DB_USER . ":" . DB_PASSWORD . "\@" . DB_HOST . "/" . DB_NAME;

1;
```

File ./config.pm:
```perl
package config;

config_module 'Query' => {
    DB_HOST => "mydb.com",
};

1;
```

What happened:
```perl
use Query;

$Query::connect # => mysql://root:pass@mydb.com

```

# DESCRIPTION

Config make constant as `use constant`, but it values substitutes on values from local config if exists.

Local config is the **./.config.pm** in root folder of the project.

The project must start from this folder in order for the **./.config.pm** to be read.

## METHODS

# import

```perl
# One constant
use config A => 10;

A # => 10;

# Multiconstants:
use config {
    B => 3,
    C => 4,
};

B # => 3
C # => 4

# And in runtime:
config->import(D => 5);

D # => 5
```

# config_module

Subroutine use in local config (**./.config.pm**) for configure perl module. To do this, the config must have `package config`.

It is not recommended to do so:

```perl

```