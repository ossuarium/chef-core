name             'core'
maintainer       'OurTownRentals.com'
maintainer_email 'evan@ourtownrentals.com'
license          'All rights reserved'
description      'Core infrastructure for OurTownRentals.com.'
version          '0.0.0'

supports 'Ubuntu', '14.04'

depends 'apache2', '~> 3.0.1'
depends 'apt', '~> 2.7.0'
depends 'annoyances', '~> 1.0.0'
depends 'build-essential', '~> 2.2.3'
depends 'cron', '~> 1.6.1'
depends 'database', '~> 4.0.6'
depends 'firewall', '~> 1.1.0'
depends 'logrotate', '~> 1.9.1'
depends 'mysql', '~> 6.0.9'
depends 'mysql2_chef_gem', '~> 1.0.1'
depends 'nfs', '~> 2.1.0'
depends 'nginx', '~> 2.7.2'
depends 'ntp', '~> 1.8.2'
depends 'nodejs', '~> 2.4.0'
depends 'oh-my-zsh', '~> 0.4.3'
depends 'openssh', '~> 1.4.0'
depends 'partial_search', '~> 1.0.7'
depends 'php', '~> 1.5.0'
depends 'php-modules', '~> 0.0.0'
depends 'phpmyadmin', '~> 0.0.0'
depends 'php-fpm', '~> 0.7.4'
depends 'rbenv', '~> 1.7.1'
depends 'ssl', '~> 1.1.1'
depends 'sudo', '~> 2.7.0'
depends 'timezone-ii', '~> 0.2.0'
depends 'users', '~> 1.8.2'
depends 'vim', '~> 1.1.2'
depends 'zsh', '~> 1.0.0'

recipe 'core::default', 'Configures a minimal base system.'
recipe 'core::firewall', 'Configures a firewall.'
recipe 'core::storage_server', 'Configures an NFS storage server.'
recipe 'core::mysql_server', 'Configures a MySQL server.'
recipe 'core::ssl_certificates', 'Installs SSL certificates from encrypted data bags.'
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
          description: 'Apps to create on the node.',
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
          description: 'Whether to include the common system configuration.',
          type: 'boolean',
          recipes: ['core::lamp_app_server',],
          default: true

attribute 'core/contact',
          display_name: 'Contact',
          description: 'Administrative contact email.',
          type: 'string',
          default: 'evan@ourtownrentals.com'

attribute 'core/deployer/user',
          display_name: 'Deployer username',
          description: 'System username for the deployer user.',
          type: 'string',
          recipes: ['core::deployment'],
          default: 'deployer'

attribute 'core/deployer/home_dir',
          display_name: 'Deployer home directory',
          description: 'Home directory for the deployer user.',
          type: 'string',
          recipes: ['core::deployment'],
          default: "node['core']['home_dir']/node['core']['deployer']['user']"

attribute 'core/deployer/sudo_commands',
          display_name: 'Deployer sudo commands',
          description: 'Commands the deployer user is allowed to run as root using sudo.',
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            '/bin/chgrp',
          ]

attribute 'core/deployers/name',
          display_name: 'Deployers group',
          description: 'Group name for the deployers group.',
          type: 'string',
          recipes: ['core::deployment'],
          default: 'deployers'

attribute 'core/deployers/gid',
          display_name: 'Deployers group id',
          description: 'Group id for the deployers group.',
          type: 'numeric',
          recipes: ['core::deployment'],
          default: 3300

attribute 'core/deployers/deployments_dir',
          display_name: 'Deployers deployments directory',
          description: "Directory under each deploy user's home directory for deployments.",
          type: 'string',
          recipes: ['core::deployment'],
          default: 'deployments'

attribute 'core/deployers/dirs',
          display_name: 'Deployers directories',
          description: "Directories to create under each deployer's home directory.",
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            '.bundle',
          ]

attribute 'core/deployers/files',
          display_name: 'Deployers files',
          description: "Files to create under each deployer's home directory.",
          type: 'hash',
          recipes: ['core::deployment'],
          default: {
            'ruby-.gemrc' => '.gemrc',
            'bundler-config' => '.bundle/config',
          }

attribute 'core/deployers/npm_packages',
          display_name: 'Deployers Node packages',
          description: 'Node packages to install via npm for each deployer.',
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            {name: 'bower', version: '1.3.5'},
          ]

attribute 'core/deployers/ruby_version',
          display_name: 'Deployers Ruby version',
          description: 'Ruby version each deployer will use.',
          type: 'string',
          recipes: ['core::deployment'],
          default: '2.1.2'

attribute 'core/deployers/gems',
          display_name: 'Deployers Ruby gems',
          description: 'Ruby gems to install for each deployer.',
          type: 'array',
          recipes: ['core::deployment'],
          default: [
            {name: 'bundler', version: '~> 1.6'},
          ]

attribute 'core/deployment/packages',
          display_name: 'Deployment packages',
          description: 'Additional packages required for deployments.',
          type: 'array',
          recipes: ['core::deployment'],
          default: []

attribute 'core/deployments',
          display_name: 'Deployments',
          description: 'Deployments to create on the node.',
          type: 'hash',
          recipes: ['core::deployment'],
          default: {}

attribute 'core/lamp/handler_extensions',
          display_name: 'Handler extensions',
          description: 'File extensions to process with FCGI.',
          type: 'array',
          recipes: ['core::lamp_app_server'],
          default: ['php']

attribute 'core/lamp/pass_header',
          display_name: 'Pass header',
          description: 'Headers to pass to FCGI.',
          type: 'array',
          recipes: ['core::lamp_app_server'],
          default: ['Authorization']

attribute 'core/lamp/thread_multiplier',
          display_name: 'Apache thread multiplier',
          description: 'Sets MaxRequestWorkers to ThreadsPerChild times this multiplier.',
          type: 'numeric',
          recipes: ['core::lamp_app_server'],
          default: 2

attribute 'core/mysql/admin',
          display_name: 'MySQL admin',
          description: 'Whether to setup phpMyAdmin on the MySQL server.',
          type: 'boolean',
          recipes: ['core::mysql_server'],
          default: false

attribute 'core/mysql/admin_alias_path',
          display_name: 'MySQL admin alias path',
          description: 'Alias path to serve phpMyAdmin from.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: nil

attribute 'core/mysql/admin_ssl',
          display_name: 'MySQL admin SSL',
          description: 'Whether to enable SSL for MySQL admin.',
          type: 'boolean',
          recipes: ['core::mysql_server'],
          default: false

attribute 'core/mysql/admin_subdomain',
          display_name: 'MySQL admin subdomain',
          description: 'Subdomain to serve phpMyAdmin from. Prepended to hostname.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: nil

attribute 'core/mysql/instance',
          display_name: 'MySQL instance name',
          description: 'Name for the MySQL instance.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: 'default'

attribute 'core/mysql/port',
          display_name: 'MySQL port',
          description: 'Port for the MySQL server.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: '3307'

attribute 'core/mysql/root_password',
          display_name: 'MySQL root password',
          description: 'Password for the MySQL root user.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: '`secure_password`'

attribute 'core/mysql/sudoroot_user',
          display_name: 'MySQL admin username',
          description: 'Username for the MySQL admin user.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: 'sudoroot'

attribute 'core/mysql/sudoroot_password',
          display_name: 'MySQL admin password',
          description: 'Password for the MySQL admin user.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: '`secure_password`'

attribute 'core/mysql/version',
          display_name: 'MySQL version',
          description: 'Version of the MySQL server.',
          type: 'string',
          recipes: ['core::mysql_server'],
          default: '5.5'

attribute 'core/packages',
          display_name: 'Packages',
          description: 'Additional packages to install.',
          type: 'array',
          default: []

attribute 'core/service/dirs',
          display_name: 'Service directories',
          description: "Directories to create under each service's directory.",
          type: 'string',
          default: [
            'shared',
          ]

attribute 'core/services',
          display_name: 'Services',
          description: 'Services to create on the node.',
          type: 'hash',
          recipes: ['core::services'],
          default: {}

attribute 'core/ssl',
          display_name: 'SSL',
          description: 'SSL support.',
          type: 'boolean',
          recipes: [
            'core::default',
            'core::lamp_app_server',
          ],
          default: false

attribute 'core/storage',
          display_name: 'Storage',
          description: 'Storage to create on the node.',
          type: 'hash',
          recipes: ['core::storage'],
          default: {}

attribute 'core/storage_access',
          display_name: 'Storage access',
          description: 'Storage access permissions.',
          type: 'hash',
          recipes: ['core::storage'],
          default: {}
