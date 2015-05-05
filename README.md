# core

[![All rights reserved](https://img.shields.io/badge/license-All_rights_reserved-red.svg)](./LICENSE.txt)

## Description

Core infrastructure for OurTownRentals.com.

### Usage


## Requirements

### Platforms

* Ubuntu (= 14.04)

### Cookbooks:

* apache2 (~> 3.0.1)
* apt (~> 2.7.0)
* annoyances (~> 1.0.0)
* build-essential (~> 2.2.3)
* cron (~> 1.6.1)
* database (~> 4.0.6)
* firewall (~> 1.1.0)
* logrotate (~> 1.9.1)
* mysql (~> 6.0.9)
* mysql2_chef_gem (~> 1.0.1)
* nfs (~> 2.1.0)
* nginx (~> 2.7.2)
* ntp (~> 1.8.2)
* nodejs (~> 2.4.0)
* oh-my-zsh (~> 0.4.3)
* openssh (~> 1.4.0)
* partial_search (~> 1.0.7)
* php (~> 1.5.0)
* php-modules (~> 0.0.0)
* phpmyadmin (~> 0.0.0)
* php-fpm (~> 0.7.4)
* rbenv (~> 1.7.1)
* ssl (~> 1.1.1)
* sudo (~> 2.7.0)
* timezone-ii (~> 0.2.0)
* users (~> 1.8.2)
* vim (~> 1.1.2)
* zsh (~> 1.0.0)

## Attributes

Attribute | Description | Default | Choices
----------|-------------|---------|--------
`node['core']['apps']` | `Apps to create on the node.` | {} |
`node['core']['common_system']` | `Whether to include the common system configuration.` | true |
`node['core']['contact']` | `Administrative contact email.` | "evan@ourtownrentals.com" |
`node['core']['deployer']['user']` | `System username for the deployer user.` | "deployer" |
`node['core']['deployer']['home_dir']` | `Home directory for the deployer user.` | "node['core']['home_dir']/node['core']['deployer']['user']" |
`node['core']['deployer']['sudo_commands']` | `Commands the deployer user is allowed to run as root using sudo.` | ["/bin/chgrp"] |
`node['core']['deployers']['name']` | `Group name for the deployers group.` | "deployers" |
`node['core']['deployers']['gid']` | `Group id for the deployers group.` | 3300 |
`node['core']['deployers']['deployments_dir']` | `Directory under each deploy user's home directory for deployments.` | "deployments" |
`node['core']['deployers']['dirs']` | `Directories to create under each deployer's home directory.` | [".bundle"] |
`node['core']['deployers']['files']` | `Files to create under each deployer's home directory.` | {"ruby-.gemrc"=>".gemrc", "bundler-config"=>".bundle/config"} |
`node['core']['deployers']['npm_packages']` | `Node packages to install via npm for each deployer.` | [{"name"=>"bower", "version"=>"1.3.5"}] |
`node['core']['deployers']['ruby_version']` | `Ruby version each deployer will use.` | "2.1.2" |
`node['core']['deployers']['gems']` | `Ruby gems to install for each deployer.` | [{"name"=>"bundler", "version"=>"~> 1.6"}] |
`node['core']['deployment']['packages']` | `Additional packages required for deployments.` | [] |
`node['core']['deployments']` | `Deployments to create on the node.` | {} |
`node['core']['lamp']['handler_extensions']` | `File extensions to process with FCGI.` | ["php"] |
`node['core']['lamp']['pass_header']` | `Headers to pass to FCGI.` | ["Authorization"] |
`node['core']['lamp']['thread_multiplier']` | `Sets MaxRequestWorkers to ThreadsPerChild times this multiplier.` | 2 |
`node['core']['mysql']['admin']` | `Whether to setup phpMyAdmin on the MySQL server.` | false |
`node['core']['mysql']['admin_alias_path']` | `Alias path to serve phpMyAdmin from.` | nil |
`node['core']['mysql']['admin_ssl']` | `Whether to enable SSL for MySQL admin.` | false |
`node['core']['mysql']['admin_subdomain']` | `Subdomain to serve phpMyAdmin from. Prepended to hostname.` | nil |
`node['core']['mysql']['instance']` | `Name for the MySQL instance.` | "default" |
`node['core']['mysql']['port']` | `Port for the MySQL server.` | "3307" |
`node['core']['mysql']['root_password']` | `Password for the MySQL root user.` | "`secure_password`" |
`node['core']['mysql']['sudoroot_user']` | `Username for the MySQL admin user.` | "sudoroot" |
`node['core']['mysql']['sudoroot_password']` | `Password for the MySQL admin user.` | "`secure_password`" |
`node['core']['mysql']['version']` | `Version of the MySQL server.` | "5.6" |
`node['core']['packages']` | `Additional packages to install.` | [] |
`node['core']['service']['dirs']` | `Directories to create under each service's directory.` | ["shared"] |
`node['core']['services']` | `Services to create on the node.` | {} |
`node['core']['ssl']` | `SSL support.` | false |
`node['core']['storage']` | `Storage to create on the node.` | {} |
`node['core']['storage_access']` | `Storage access permissions.` | {} |

## Recipes

* core::default - Configures a minimal base system.
* core::firewall - Configures a firewall.
* core::storage_server - Configures an NFS storage server.
* [core::mysql_server](#coremysql_server) - Configures a MySQL server.
* core::ssl_certificates - Installs SSL certificates from encrypted data bags.
* core::static_app_server - Configures a static web server.
* [core::lamp_app_server](#corelamp_app_server) - Configures the Apache HTTP Server, MySQL client, PHP-FPM.
* core::services - Create core_services based on attributes.
* [core::deployment](#coredeployment) - Sets up the deployer user and deployers group.

### core::mysql_server

This will configure a MySQL server and optionally
setup phpMyAdmin running on Apache using FastCGI and PHP-FPM.


### core::lamp_app_server

This installs the Apache HTTP Server, MySQL client, PHP-FPM,
and the necessary modules to host a PHP application using mod_fastcgi.

This also installs the [database cookbook].

[database cookbook]: http://community.opscode.com/cookbooks/database


### core::deployment

_This recipe should generally be placed near the end of the run list._

Users are added to the deployers groups using the [users cookbook]
with the group name `deployers`.

This installs nodejs and a set of default npm packages.

This installs rbenv for each deployer along with
a Ruby version and a set of default gems (including Bundler).

[users cookbook]: http://community.opscode.com/cookbooks/users


## Resources

* [core_deployment](#core_deployment)
* [core_lamp_app](#core_lamp_app) - Each LAMP app must be assigned a `core_service`.
* [core_service](#core_service) - A service is the top-level organizational unit for providing web services.
* [core_static_app](#core_static_app) - Each static app must be assigned a `core_service`.

### core_deployment



#### Actions

- create: creates the deployment. Default action.
- delete: deletes the deployment.

#### Attribute Parameters

- name: the name of the deployment.
- apps: the apps this deployment will deploy to, Defaults to <code>[]</code>.

### core_lamp_app

Each LAMP app must be assigned a `core_service`.

#### Actions

- create: creates the LAMP app. Default action.
- delete: deletes the LAMP app.
- destroy: deletes the instance, database, and shared directory.

#### Attribute Parameters

- name: the unique name of the LAMP app.
- moniker: the name of the LAMP app.
- service: the service to create the LAMP app under.
- shared: the shared paths to create. Defaults to <code>[]</code>.
- storage: the shared paths to mount as storage. Defaults to <code>{}</code>.
- fpm: whether to setup an FPM socket for this app. Defaults to <code>true</code>.
- fpm_pool: php_fpm_pool resource to use (created if not set).
- php_options: php options to set for the FPM pool. Defaults to <code>{}</code>.
- database: whether to setup a database for this app. Defaults to <code>false</code>.
- mysql_connection: MySQL admin connection information.
- db_name: database name to use for the LAMP app.
- db_user: MySQL username to use to connect to the database.
- db_password: MySQL password to use to connect to the database.
- db_client: host part of the MySQL username to use when creating the user.

### core_service

A service is the top-level organizational unit for providing web services.
Each service will have its own directory under `node['core']['srv_dir']`
and a corresponding configuration directory for the installed web server.

A set of default directories to create for each service under its
primary directory is set in `node['core']['service']['dirs']`.

#### Actions

- create: creates the service. Default action.
- delete: deletes the service.

#### Attribute Parameters

- name: the name of the service.

### core_static_app

Each static app must be assigned a `core_service`.

#### Actions

- create: creates the static app. Default action.
- delete: deletes the static app.

#### Attribute Parameters

- name: the unique name of the static app.
- moniker: the name of the static app.
- service: the service to create the static app under.
- storage: the shared paths to mount as storage. Defaults to <code>{}</code>.

## Development and Testing

### Source Code

The [core source](https://github.com/ourtownrentals/chef-core)
is hosted on GitHub.
To clone the project run

```bash
$ git clone https://github.com/ourtownrentals/chef-core.git
```

### Rake

Run `rake -T` to see all Rake tasks.

```
rake all                          # Run all tasks
rake doc                          # Build documentation
rake foodcritic                   # Lint Chef cookbooks
rake kitchen:all                  # Run all test instances
rake kitchen:default-ubuntu-1404  # Run default-ubuntu-1404 test instance
rake readme                       # Generate README.md from _README.md.erb
rake rubocop                      # Run RuboCop
rake rubocop:auto_correct         # Auto-correct RuboCop offenses
rake spec                         # Run RSpec code examples
rake test                         # Run kitchen integration tests
rake yard                         # Generate YARD Documentation
```

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

1. Fork it (https://github.com/ourtownrentals/chef-core/fork).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Make changes. Write and run tests.
4. Commit your changes (`git commit -am 'Add some feature'`).
5. Push to the branch (`git push origin my-new-feature`).
6. Create a new Pull Request.

## License

Copyright © 2014-2015 OurTownRentals.com

## Warranty

This software is provided "as is" and without any express or
implied warranties, including, without limitation, the implied
warranties of merchantibility and fitness for a particular
purpose.
