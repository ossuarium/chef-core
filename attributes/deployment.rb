#
# Cookbook Name:: core
# Attributes:: deployment
#

#
# Deployment configuration.
#

default['core']['deployment']['packages'] = []

#
# Deployer user configuration.
#

default['core']['deployer']['user'] = 'deployer'
default['core']['deployer']['home_dir'] = "#{node['core']['home_dir']}/#{node['core']['deployer']['user']}"

default['core']['deployer']['sudo_commands'] = %w(/bin/chgrp)

#
# Deployers group configuration.
#

default['core']['deployers']['name'] = 'deployers'
default['core']['deployers']['gid'] = 3300
default['core']['deployers']['deployments_dir'] = 'deployments'
default['core']['deployers']['ruby_version'] = '2.1.2'
default['core']['deployers']['gems'] = [
  {name: 'bundler', version: '~> 1.6'},
]
default['core']['deployers']['npm_packages'] = [
  {name: 'bower', version: '1.3.5'},
]
default['core']['deployers']['dirs'] = [
  '.bundle',
]
default['core']['deployers']['files'] = {
  'ruby-.gemrc' => '.gemrc',
  'bundler-config' => '.bundle/config',
}

#
# Deployments
#

default['core']['deployments'] = {}
