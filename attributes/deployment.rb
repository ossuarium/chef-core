#
# Cookbook Name:: otr
# Attributes:: deployment
#

#
# Deployer user configuration.
#

default['otr']['deployer']['user'] = 'deployer'
default['otr']['deployer']['home_dir'] = "#{node['otr']['home_dir']}/#{node['otr']['deployer']['user']}"

default['otr']['deployer']['sudo_commands'] = [
  '/bin/chgrp',
]

#
# Deployers group configuration.
#

default['otr']['deployers']['name'] = 'deployers'
default['otr']['deployers']['gid'] = 3300
default['otr']['deployers']['deployments_dir'] = 'deployments'
default['otr']['deployers']['ruby_version'] = '2.1.2'
default['otr']['deployers']['gems'] = [
  {name: 'bundler', version: '~> 1.6'},
]
default['otr']['deployers']['npm_packages'] = [
  {name: 'bower', version: '1.3.5'},
]
default['otr']['deployers']['dirs'] = [
  '.bundle',
]
default['otr']['deployers']['files'] = {
  'ruby-.gemrc' => '.gemrc',
  'bundler-config' => '.bundle/config',
}
