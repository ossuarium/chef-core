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

attribute 'otr/phpmyadmin/pma_database',
  display_name: 'phpMyAdmin database name',
  description: 'Name to use for the phpMyAdmin control database.',
  type: 'string',
  recipes: ['otr::mysql_server'],
  default: 'phpmyadmin'

attribute 'otr/phpmyadmin/pma_username',
  display_name: 'phpMyAdmin database username',
  description: 'MySQL username for access to the phpMyAdmin control database.',
  type: 'string',
  recipes: ['otr::mysql_server'],
  default: 'phpmyadmin'
