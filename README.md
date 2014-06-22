# otr

[![All rights reserved](http://img.shields.io/badge/license-All_rights_reserved-red.svg?style=flat)](./LICENSE.txt)

## Description

Core infrastructure for OurTownRentals.com.

## Requirements

### Platforms

* Ubuntu (14.04)

### Cookbooks:

* apache2 (~> 1.8.15)
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
* php (~> 1.2.0)
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
`node['otr']['run_dir']` | `"/var/run"` |  |
`node['otr']['servers']` | `"{ ... }"` |  |
`node['otr']['phpmyadmin']['pma_database']` | `"phpmyadmin"` |  |
`node['otr']['phpmyadmin']['pma_username']` | `"phpmyadmin"` |  |
`node['otr']['deployer']['user']` | `"deployer"` |  |
`node['otr']['deployer']['home_dir']` | `"/home/\#{node['otr']['deployer']['user']}"` |  |
`node['otr']['deployer']['sudo_commands']` | `"[ ... ]"` |  |
`node['otr']['deployers']['name']` | `"deployers"` |  |
`node['otr']['deployers']['gid']` | `"3300"` |  |
`node['otr']['deployers']['deployments_dir']` | `"deployments"` |  |
`node['otr']['deployers']['ruby_version']` | `"2.1.2"` |  |
`node['otr']['deployers']['gems']` | `"[ ... ]"` |  |
`node['otr']['deployers']['npm']['packages']` | `"{ ... }"` |  |
`node['otr']['deployers']['dirs']` | `"[ ... ]"` |  |
`node['otr']['deployers']['files']` | `"{ ... }"` |  |

## Recipes

* otr::default - Configures a minimal base system.
* otr::deployment - Sets up the deployer user and deployers group.
* otr::lamp_app_server - Configures the Apache HTTP Server, MySQL client, PHP-FPM.

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
