#
# Cookbook Name:: otr
# Recipe:: deployment
#

#
# Setup deployer user.
#

user node['otr']['deployer']['user'] do
  shell '/bin/bash'
  home node['otr']['deployer']['home_dir']
  system true
  supports manage_home: true
  action :create
end

directory "#{node['otr']['deployer']['home_dir']}/bin" do
  owner node['otr']['deployer']['user']
  group node['otr']['deployers']['name']
  mode '0750'
  action :create
end

sudo 'deployer' do
  user node['otr']['deployer']['user']
  nopasswd true
  commands node['otr']['deployer']['sudo_commands']
end

#
# Setup deployers.
#

search(
  'users', "groups:#{node['otr']['deployers']['name']} AND NOT action:remove"
).each do |user|
  home = "/home/#{user.id}"

  node.default['rbenv']['user_installs'] << {
    user: user.id,
    rubies: [node['otr']['deployers']['ruby_version']],
    global: node['otr']['deployers']['ruby_version'],
    gems: {
      node['otr']['deployers']['ruby_version'] => node['otr']['deployers']['gems']
    }
  }

  directory node['otr']['deployers']['deployments_dir'] do
    owner user.id
    group node['otr']['deployer']['user']
    mode '0750'
    action :create
  end

  node['otr']['deployers']['dirs'].each do |path|
    directory "#{home}/#{path}" do
      owner user.id
      group user.id
      mode '0750'
      action :create
    end
  end

  node['otr']['deployers']['files'].each do |src, dest|
    cookbook_file src do
      path "#{home}/#{dest}"
      owner user.id
      group user.id
      mode '0640'
      action :create
    end
  end
end

#
# Install nodejs packages.
#

include_recipe 'nodejs::default'

node['otr']['deployers']['npm']['packages'].each do |pkg, ver|
  nodejs_npm pkg do
    version ver
    action :install
  end
end

#
# Install rbenv, Ruby, and gems for deployers.
#

include_recipe 'ruby_build::default'
include_recipe 'rbenv::user'
