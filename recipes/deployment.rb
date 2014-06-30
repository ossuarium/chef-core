#
# Cookbook Name:: otr
# Recipe:: deployment
#

=begin
#<
_This recipe should generally be placed near the end of the run list._

Users are added to the deployers groups using the [users cookbook]
with the group name `deployers`.

This installs nodejs and a set of default npm packages.

This installs rbenv for each deployer along with
a Ruby version and a set of default gems (including Bundler).

[users cookbook]: http://community.opscode.com/cookbooks/users
#>
=end

#
# Set git references to use for ruby-build and rbenv.
#

node.default['ruby_build']['git_ref'] = 'master'
node.default['rbenv']['git_ref'] = 'master'

include_recipe 'otr::_common_system'
include_recipe 'build-essential::default'

#
# Setup deployer user.
#

user node['otr']['deployer']['user'] do
  shell '/bin/bash'
  home node['otr']['deployer']['home_dir']
  system true
  supports manage_home: true
end

directory "#{node['otr']['deployer']['home_dir']}/bin" do
  owner node['otr']['deployer']['user']
  group node['otr']['deployers']['name']
  mode '0750'
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
  home = "#{node['otr']['home_dir']}/#{user.id}"

  node.default['rbenv']['user_installs'] << {
    user: user.id,
    rubies: [node['otr']['deployers']['ruby_version']],
    global: node['otr']['deployers']['ruby_version'],
    gems: {
      node['otr']['deployers']['ruby_version'] => node['otr']['deployers']['gems']
    }
  }

  directory "#{home}/#{node['otr']['deployers']['deployments_dir']}" do
    owner user.id
    group node['otr']['deployer']['user']
    mode '0750'
  end

  node['otr']['deployers']['dirs'].each do |path|
    directory "#{home}/#{path}" do
      owner user.id
      group user.id
      mode '0750'
    end
  end

  node['otr']['deployers']['files'].each do |src, dest|
    cookbook_file src do
      path "#{home}/#{dest}"
      owner user.id
      group user.id
      mode '0640'
    end
  end
end

#
# Install nodejs packages.
#

include_recipe 'nodejs::default'

node['otr']['deployers']['npm_packages'].each do |pkg|
  nodejs_npm pkg[:name] do
    version pkg[:version]
  end
end

#
# Install rbenv, Ruby, and gems for deployers.
#

node.set['ruby_build']['upgrade'] = 'sync'
node.set['rbenv']['upgrade'] = 'sync'

include_recipe 'ruby_build::default'
include_recipe 'rbenv::user'
