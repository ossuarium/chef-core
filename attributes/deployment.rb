#
# Cookbook Name:: otr
# Attributes:: deployment
#

#
# Deployer user configuration.
#

# Deployer username and home directory.
default['otr']['deployer']['user'] = 'deployer'
default['otr']['deployer']['home_dir'] = "/home/#{node['otr']['deployer']['user']}"

# Commands deployer can run as root via sudo.
default['otr']['deployer']['sudo_commands'] = [
  '/bin/chgrp',
]

#
# Deployers group configuration.
#

# Group name and id.
default['otr']['deployers']['name'] = 'deployers'
default['otr']['deployers']['gid'] = 3300

# Directory under each deployer's home directory to put deployments.
default['otr']['deployers']['deployments_dir'] = 'deployments'

# Ruby version each deployer will use.
default['otr']['deployers']['ruby_version'] = '2.1.1'

# Ruby gems to install.
default['otr']['deployers']['gems'] = [
  {name: 'bundler', version: '~> 1.6'},
]

# Node packages to install via npm.
# 'package' => 'version'
default['otr']['deployers']['npm']['packages'] = {
  'bower' => '1.3.5',
}

# Directories to create under each deployer's home directory.
default['otr']['deployers']['dirs'] = [
  '.bundle',
]

# Files to create under each deployer's home directory.
# 'file' => 'install_path'
default['otr']['deployers']['files'] = {
  'ruby-.gemrc' => '.gemrc',
  'bundler-config' => '.bundle/config',
}
