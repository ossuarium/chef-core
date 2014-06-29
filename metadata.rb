name             'otr'
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
depends 'mysql', '~> 5.3.6'
depends 'nginx', '~> 2.7.2'
depends 'ntp', '~> 1.6.2'
depends 'nodejs', '~> 1.3.0'
depends 'oh-my-zsh', '~> 0.4.3'
depends 'openssh', '~> 1.3.4'
depends 'php', '~> 1.2.3'
depends 'phpmyadmin', '~> 1.0.6'
depends 'rbenv', '~> 0.7.3'
depends 'ruby_build', '~> 0.8.0'
depends 'sudo', '~> 2.6.0'
depends 'timezone-ii', '~> 0.2.0'
depends 'users', '~> 1.7.0'
depends 'vim', '~> 1.1.2'
depends 'zsh', '~> 1.0.0'

recipe 'otr::default', 'Configures a minimal base system.'
recipe 'otr::deployment', 'Sets up the deployer user and deployers group.'
recipe 'otr::lamp_app_server', 'Configures the Apache HTTP Server, MySQL client, PHP-FPM.'
recipe 'otr::mysql_server', 'Configures a MySQL server.'

provides 'service[otr_service]'

attribute 'otr/deployer/user',
          display_name: 'Deployer username',
          description: %q{System username for the deployer user.},
          type: 'string',
          recipes: ['otr::deployment'],
          default: 'deployer'

attribute 'otr/deployer/home_dir',
          display_name: 'Deployer home directory',
          description: %q{Home directory for the deployer user.},
          type: 'string',
          recipes: ['otr::deployment'],
          default: %q{/home/node['otr']['deployer']['user']}

attribute 'otr/deployer/sudo_commands',
          display_name: 'Deployer sudo commands',
          description: %q{Commands the deployer user is allowed to run as root using sudo.},
          type: 'array',
          recipes: ['otr::deployment'],
          default: [
            '/bin/chgrp',
          ]

attribute 'otr/deployers/name',
          display_name: 'Deployers group',
          description: %q{Group name for the deployers group.},
          type: 'string',
          recipes: ['otr::deployment'],
          default: 'deployers'

attribute 'otr/deployers/gid',
          display_name: 'Deployers group id',
          description: %q{Group id for the deployers group.},
          type: 'numeric',
          recipes: ['otr::deployment'],
          default: 3300

attribute 'otr/deployers/deployments_dir',
          display_name: 'Deployers deployments directory',
          description: %q{Directory under each deploy user's home directory for deployments.},
          type: 'string',
          recipes: ['otr::deployment'],
          default: 'deployments'

attribute 'otr/deployers/dirs',
          display_name: 'Deployers directories',
          description: %q{Directories to create under each deployer's home directory.},
          type: 'array',
          recipes: ['otr::deployment'],
          default: [
            '.bundle',
          ]

attribute 'otr/deployers/files',
          display_name: 'Deployers files',
          description: %q{Files to create under each deployer's home directory.},
          type: 'hash',
          recipes: ['otr::deployment'],
          default: {
            'ruby-.gemrc' => '.gemrc',
            'bundler-config' => '.bundle/config',
          }

attribute 'otr/deployers/npm_packages',
          display_name: 'Deployers Node packages',
          description: %q{Node packages to install via npm for each deployer.},
          type: 'array',
          recipes: ['otr::deployment'],
          default: [
            {name: 'bower', version: '1.3.5'},
          ]

attribute 'otr/deployers/ruby_version',
          display_name: 'Deployers Ruby version',
          description: %q{Ruby version each deployer will use.},
          type: 'string',
          recipes: ['otr::deployment'],
          default: '2.1.2'

attribute 'otr/deployers/gems',
          display_name: 'Deployers Ruby gems',
          description: %q{Ruby gems to install for each deployer.},
          type: 'array',
          recipes: ['otr::deployment'],
          default: [
            {name: 'bundler', version: '~> 1.6'},
          ]

attribute 'otr/mysql_sudoroot_user',
          display_name: 'MySQL admin username',
          description: %q{Username for the MySQL admin user.},
          type: 'string',
          recipes: ['otr::mysql_server'],
          default: 'sudoroot'

attribute 'otr/mysql_sudoroot_password',
          display_name: 'MySQL admin password',
          description: %q{Password for the MySQL admin user.},
          type: 'string',
          recipes: ['otr::mysql_server'],
          default: '`secure_password`'

attribute 'otr/phpmyadmin/pma_database',
          display_name: 'phpMyAdmin database name',
          description: %q{Name to use for the phpMyAdmin control database.},
          type: 'string',
          recipes: ['otr::mysql_server'],
          default: 'phpmyadmin'

attribute 'otr/phpmyadmin/pma_username',
          display_name: 'phpMyAdmin database username',
          description: %q{MySQL username for access to the phpMyAdmin control database.},
          type: 'string',
          recipes: ['otr::mysql_server'],
          default: 'phpmyadmin'

attribute 'otr/service/dirs',
          display_name: 'Service directories',
          description: %q{Directories to create under each service's directory.},
          type: 'string',
          default: [
            'shared',
          ]
