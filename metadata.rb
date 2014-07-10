name             'core'
maintainer       'OurTownRentals.com'
maintainer_email 'evan@ourtownrentals.com'
license          'All rights reserved'
description      'Core infrastructure for OurTownRentals.com.'
version          '0.0.0'

supports 'Ubuntu', '14.04'

depends 'apache2', '~> 1.10.5'
depends 'apt', '~> 2.4.0'
depends 'annoyances', '~> 1.0.0'
depends 'build-essential', '~> 2.0.4'
depends 'database', '~> 2.2.0'
depends 'firewall', '~> 0.11.8'
depends 'logrotate', '~> 1.6.0'
depends 'mysql', '~> 5.3.6'
depends 'nfs', '~> 2.0.0'
depends 'nginx', '~> 2.7.2'
depends 'ntp', '~> 1.6.2'
depends 'nodejs', '~> 1.3.0'
depends 'oh-my-zsh', '~> 0.4.3'
depends 'openssh', '~> 1.3.4'
depends 'partial_search', '~> 1.0.7'
depends 'php', '~> 1.4.7'
depends 'php-ioncube', '~> 0.2.0'
depends 'phpmyadmin', '~> 0.0.0'
depends 'php-fpm', '~> 0.6.10'
depends 'rbenv', '~> 0.7.3'
depends 'ruby_build', '~> 0.8.0'
depends 'sudo', '~> 2.6.0'
depends 'timezone-ii', '~> 0.2.0'
depends 'users', '~> 1.7.0'
depends 'vim', '~> 1.1.2'
depends 'zsh', '~> 1.0.0'

recipe 'core::default', 'Configures a minimal base system.'
recipe 'core::firewall', 'Configures a firewall.'
recipe 'core::storage_server', 'Configures an NFS storage server.'
recipe 'core::mysql_server', 'Configures a MySQL server.'
recipe 'core::static_app_server', 'Configures a static web server.'
recipe 'core::lamp_app_server', 'Configures the Apache HTTP Server, MySQL client, PHP-FPM.'
recipe 'core::services', 'Create core_services based on attributes.'
recipe 'core::deployment', 'Sets up the deployer user and deployers group.'

provides 'service[core_service]'
provides 'service[core_deployment]'
provides 'service[core_storage]'
provides 'service[core_lamp_app]'
provides 'service[core_static_app]'

attribute 'core/apps',
          display_name: 'Apps',
          description: %q{Apps to create on the node.},
          type: 'hash',
          recipes: [
            'core::default',
            'core::deployment',
            'core::lamp_app_server',
            'core::mysql_server',
          ],
          default: {}

attribute 'core/common_system',
          display_name: 'Common system',
          description: %q{Whether to include the common system configuration.},
          type: 'boolean',
          recipes: ['core::lamp_app_server',],
          default: true

attribute 'core/contact',
          display_name: 'Contact',
          description: %q{Administrative contact email.},
          type: 'string',
          default: 'evan@ourtownrentals.com'

attribute 'core/deployer/user',
          display_name: 'Deployer username',
          description: %q{System username for the deployer user.},
          type: 'string',
          recipes: ['core::deployment'],
          default: 'deployer'

attribute 'core/deployer/home_dir',
          display_name: 'Deployer home directory',
          description: %q{Home directory for the deployer user.},
          type: 'string',
          recipes: ['core::deployment'],
          default: %q{node['core']['home_dir']/node['core']['deployer']['user']}

attribute 'core/deployer/sudo_commands',
          display_name: 'Deployer sudo commands',
          description: %q{Commands the deployer user is allowed to run as root using sudo.},
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            '/bin/chgrp',
          ]

attribute 'core/deployers/name',
          display_name: 'Deployers group',
          description: %q{Group name for the deployers group.},
          type: 'string',
          recipes: ['core::deployment'],
          default: 'deployers'

attribute 'core/deployers/gid',
          display_name: 'Deployers group id',
          description: %q{Group id for the deployers group.},
          type: 'numeric',
          recipes: ['core::deployment'],
          default: 3300

attribute 'core/deployers/deployments_dir',
          display_name: 'Deployers deployments directory',
          description: %q{Directory under each deploy user's home directory for deployments.},
          type: 'string',
          recipes: ['core::deployment'],
          default: 'deployments'

attribute 'core/deployers/dirs',
          display_name: 'Deployers directories',
          description: %q{Directories to create under each deployer's home directory.},
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            '.bundle',
          ]

attribute 'core/deployers/files',
          display_name: 'Deployers files',
          description: %q{Files to create under each deployer's home directory.},
          type: 'hash',
          recipes: ['core::deployment'],
          default: {
            'ruby-.gemrc' => '.gemrc',
            'bundler-config' => '.bundle/config',
          }

attribute 'core/deployers/npm_packages',
          display_name: 'Deployers Node packages',
          description: %q{Node packages to install via npm for each deployer.},
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            {name: 'bower', version: '1.3.5'},
          ]

attribute 'core/deployers/ruby_version',
          display_name: 'Deployers Ruby version',
          description: %q{Ruby version each deployer will use.},
          type: 'string',
          recipes: ['core::deployment'],
          default: '2.1.2'

attribute 'core/deployers/gems',
          display_name: 'Deployers Ruby gems',
          description: %q{Ruby gems to install for each deployer.},
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            {name: 'bundler', version: '~> 1.6'},
          ]

attribute 'core/deployment/packages',
          display_name: 'Deployment packages',
          description: %q{Additional packages required for deployments.},
          type: 'array',
          recipes: ['core::deployment'],
          default: []

attribute 'core/deployments',
          display_name: 'Deployments',
          description: %q{Deployments to create on the node.},
          type: 'hash',
          recipes: ['core::deployment'],
          default: {}

attribute 'core/lamp/handler_extensions',
          display_name: 'Handler extensions',
          description: %q{File extensions to process with FCGI.},
          type: 'array',
          recipes: ['core::lamp_app_server'],
          default: ['php']

attribute 'core/lamp/pass_header',
          display_name: 'Pass header',
          description: %q{Headers to pass to FCGI.},
          type: 'array',
          recipes: ['core::lamp_app_server'],
          default: ['Authorization']

attribute 'core/lamp/ioncube',
          display_name: 'ionCube',
          description: %q{Whether install and enable ionCube.},
          type: 'boolean',
          recipes: ['core::lamp_app_server'],
          default: false

attribute 'core/mysql_admin',
          display_name: 'MySQL admin',
          description: %q{Whether to setup phpMyAdmin on the MySQL server.},
          type: 'boolean',
          recipes: ['core::mysql_server'],
          default: false

attribute 'core/mysql_admin_subdomain',
          display_name: 'MySQL admin subdomain',
          description: %q{Subdomain to serve phpMyAdmin from. Prepended to hostname.},
          type: 'string',
          recipes: ['core::mysql_server'],
          default: nil

attribute 'core/mysql_sudoroot_user',
          display_name: 'MySQL admin username',
          description: %q{Username for the MySQL admin user.},
          type: 'string',
          recipes: ['core::mysql_server'],
          default: 'sudoroot'

attribute 'core/mysql_sudoroot_password',
          display_name: 'MySQL admin password',
          description: %q{Password for the MySQL admin user.},
          type: 'string',
          recipes: ['core::mysql_server'],
          default: '`secure_password`'

attribute 'core/packages',
          display_name: 'Packages',
          description: %q{Additional packages to install.},
          type: 'array',
          default: []

attribute 'core/phpmyadmin/pma_database',
          display_name: 'phpMyAdmin database name',
          description: %q{Name to use for the phpMyAdmin control database.},
          type: 'string',
          recipes: ['core::mysql_server'],
          default: 'phpmyadmin'

attribute 'core/phpmyadmin/pma_username',
          display_name: 'phpMyAdmin database username',
          description: %q{MySQL username for access to the phpMyAdmin control database.},
          type: 'string',
          recipes: ['core::mysql_server'],
          default: 'phpmyadmin'

attribute 'core/service/dirs',
          display_name: 'Service directories',
          description: %q{Directories to create under each service's directory.},
          type: 'string',
          default: [
            'shared',
          ]

attribute 'core/services',
          display_name: 'Services',
          description: %q{Services to create on the node.},
          type: 'hash',
          recipes: ['core::services'],
          default: {}

attribute 'core/storage',
          display_name: 'Storage',
          description: %q{Storage to create on the node.},
          type: 'hash',
          recipes: ['core::storage'],
          default: {}
