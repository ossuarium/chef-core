#
# Cookbook Name:: core
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
node.default['build-essential']['compile_time'] = true

include_recipe 'core::_common_system' if node['core']['common_system']
include_recipe 'build-essential::default'

#
# Install additional packages.
#

node['core']['deployment']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

#
# Setup deployer.
#

directory "#{node['core']['deployer']['home_dir']}/bin" do
  owner node['core']['deployer']['user']
  group node['core']['deployers']['name']
  mode '0750'
end

sudo 'deployer' do
  user node['core']['deployer']['user']
  nopasswd true
  commands node['core']['deployer']['sudo_commands']
end

#
# Setup deployers.
#

search(
  'users', "groups:#{node['core']['deployers']['name']} AND NOT action:remove"
).each do |user|
  home = "#{node['core']['home_dir']}/#{user.id}"

  directory "#{home}/#{node['core']['deployers']['deployments_dir']}" do
    owner user.id
    group node['core']['deployer']['user']
  end

  node['core']['deployers']['dirs'].each do |path|
    directory "#{home}/#{path}" do
      owner user.id
      group user.id
      mode '0750'
    end
  end

  node['core']['deployers']['files'].each do |src, dest|
    cookbook_file src do
      path "#{home}/#{dest}"
      owner user.id
      group user.id
      mode '0640'
    end
  end

  node.default['rbenv']['group_users'] << user.id
end

#
# Install nodejs packages.
#

include_recipe 'nodejs::default'

node['core']['deployers']['npm_packages'].each do |pkg|
  nodejs_npm pkg[:name] do
    version pkg[:version]
  end
end

#
# Install rbenv, Ruby, and gems for deployers.
#

include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'

rbenv_ruby node['core']['deployers']['ruby_version']

node['core']['deployers']['gems'].each do |g|
  rbenv_gem g[:name] do
    version g[:version]
    ruby_version node['core']['deployers']['ruby_version']
    action :upgrade
  end
end

#
# Create deployments.
#

node['core']['deployments'].each do |deployment, params|
  core_deployment deployment do
    apps params[:apps] if params[:apps]
    action params[:action] if params[:action]
  end
end
