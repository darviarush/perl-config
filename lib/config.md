# NAME

**config** — Perl module constant configurator.

# SYNOPSIS

File lib/My/Query.pm:
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

File .config.pm:
```perl
package config;

config_module 'My::Query' => {
    DB_HOST => "mydb.com",
};

1;
```

What happened:
```perl
unshift @INC, "lib";
require My::Query;

$My::Query::connect # \> mysql://root:pass@mydb.com/mizericordia
```

# DESCRIPTION

Config make constant as `use constant`, but it values substitutes on values from local config if exists.

Local config is the **./.config.pm** in root folder of the project.

The project must start from this folder in order for the **./.config.pm** to be read.

## METHODS

# import

File lib/Example.pm:
```perl
package Example;

# One constant
use config A => 10;

# Multiconstants:
use config {
    B => 3,
    C => 4,
};

1;
```

```perl
require Example;

Example::A() # => 10
Example::B() # => 3
Example::C() # => 4

# And in runtime:
config->import('D' => 5);

D() # => 5
```

# config_module MODULE => {...}

Subroutine use in local config (**./.config.pm**) for configure perl module. To do this, the config must have `package config`.

# INSTALL

Add to **cpanfile** in your project:

```cpanfile
on 'test' => sub {
	requires 'config', 
		git => 'https://github.com/darviarush/perl-config.git',
		ref => 'master',
	;
};
```

And run command:

```sh
$ sudo cpm install -gvv
```

# LICENSE

⚖ **GPLv3**

# AUTHOR

Yaroslav O. Kosmina [dart@cpan.org](mailto:dart@cpan.org)