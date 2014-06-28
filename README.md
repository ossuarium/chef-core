# otr

[![All rights reserved](http://img.shields.io/badge/license-All_rights_reserved-red.svg?style=flat)](./LICENSE.txt)

## Description

Core infrastructure for OurTownRentals.com.

## Requirements

### Platforms

* Ubuntu (14.04)

### Cookbooks:

* apache2 (~> 1.10.5)
* apt (~> 2.4.0)
* annoyances (~> 1.0.0)
* build-essential (~> 2.0.4)
* database (~> 2.2.0)
* firewall (~> 0.11.8)
* mysql (~> 5.3.6)
* nginx (~> 2.7.2)
* ntp (~> 1.6.2)
* nodejs (~> 1.3.0)
* oh-my-zsh (~> 0.4.3)
* openssh (~> 1.3.4)
* php (~> 1.2.3)
* phpmyadmin (~> 1.0.6)
* rbenv (~> 0.7.3)
* ruby_build (~> 0.8.0)
* sudo (~> 2.6.0)
* timezone-ii (~> 0.2.0)
* users (~> 1.7.0)
* vim (~> 1.1.2)
* zsh (~> 1.0.0)

## Attributes

Attribute | Default | Description | Choices
----------|---------|-------------|--------
`node['otr']['phpmyadmin']['pma_database']` | `"phpmyadmin"` | Name to use for the phpMyAdmin control database. |
`node['otr']['phpmyadmin']['pma_username']` | `"phpmyadmin"` | MySQL username for access to the phpMyAdmin control database. |
`node['otr']['deployer']['user']` | `"deployer"` | System username for the deployer user. |
`node['otr']['deployer']['home_dir']` | `"/home/node['otr']['deployer']['user']"` | Home directory for the deployer user. |
`node['otr']['deployer']['sudo_commands']` | `["/bin/chgrp"]` | Commands the deployer user is allowed to run as root using sudo. |
`node['otr']['deployers']['name']` | `"deployers"` | Group name for the deployers group. |
`node['otr']['deployers']['gid']` | `3300` | Group id for the deployers group. |
`node['otr']['deployers']['deployments_dir']` | `"deployments"` | Directory under each deploy user's home directory for deployments. |
`node['otr']['deployers']['ruby_version']` | `"2.1.2"` | Ruby version each deployer will use. |
`node['otr']['deployers']['gems']` | `[{"name"=>"bundler", "version"=>"~> 1.6"}]` | Ruby gems to install for each deployer. |
`node['otr']['deployers']['npm_packages']` | `[{"name"=>"bower", "version"=>"1.3.5"}]` | Node packages to install via npm for each deployer. |
`node['otr']['deployers']['dirs']` | `[".bundle"]` | Directories to create under each deployer's home directory. |
`node['otr']['deployers']['files']` | `{"ruby-.gemrc"=>".gemrc", "bundler-config"=>".bundle/config"}` | Files to create under each deployer's home directory. |

## Recipes

* otr::default - Configures a minimal base system.
* [otr::deployment](#otrdeployment) - Sets up the deployer user and deployers group.
* [otr::lamp_app_server](#otrlamp_app_server) - Configures the Apache HTTP Server, MySQL client, PHP-FPM.
* [otr::mysql_server](#otrmysql_server) - Configures a MySQL server.

### otr::deployment

_This recipe should generally be placed near the end of the run list._

Users are added to the deployers groups using the [users cookbook]
with the group name `deployers`.

This installs nodejs and a set of default npm packages.

This installs rbenv for each deployer along with
a Ruby version and a set of default gems (including Bundler).

[users cookbook]: http://community.opscode.com/cookbooks/users


### otr::lamp_app_server

This installs the Apache HTTP Server, MySQL client, PHP-FPM,
and the necessary modules to host a PHP application using mod_fastcgi.

This also installs the [database cookbook].

[database cookbook]: http://community.opscode.com/cookbooks/database


### otr::mysql_server

This will configure a MySQL server and optionally
setup phpMyAdmin running on Nginx using FastCGI and PHP-FPM.


## Development and Testing

### Source Code

The [otr source](https://bitbucket.org/ourtownrentals/chef-otr)
is hosted on Bitbucket.
To clone the project run

````bash
$ git clone https://bitbucket.org/ourtownrentals/chef-otr.git
````

### Rake

Run `rake -T` to see all Rake tasks.

````
rake all                          # Run all tasks
rake doc                          # Build documentation
rake foodcritic                   # Lint Chef cookbooks
rake kitchen:all                  # Run all test instances
rake kitchen:default-centos-65    # Run default-centos-65 test instance
rake kitchen:default-ubuntu-1404  # Run default-ubuntu-1404 test instance
rake readme                       # Generate README.md from _README.md.erb
rake rubocop                      # Run RuboCop
rake rubocop:auto_correct         # Auto-correct RuboCop offenses
rake spec                         # Run RSpec code examples
rake test                         # Run kitchen integration tests
rake yard                         # Generate YARD Documentation
````

### Thor

Run `thor -T` to see all Thor tasks.

### Guard

Guard tasks have been separated into the following groups:

- `doc`
- `lint`
- `unit`
- `integration`

By default, Guard will generate documentation, lint, and run unit tests.
The integration group must be selected manually with `guard -g integration`.

## Contributing

Please submit and comment on bug reports and feature requests.

To submit a patch:

1. Fork it (https://bitbucket.org/ourtownrentals/chef-otr/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes. Write and run tests.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

Copyright © 2014 OurTownRentals.com

## Warranty

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.
