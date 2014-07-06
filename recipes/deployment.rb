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

  node.default['rbenv']['user_installs'] << {
    user: user.id,
    rubies: [node['core']['deployers']['ruby_version']],
    global: node['core']['deployers']['ruby_version'],
    gems: {
      node['core']['deployers']['ruby_version'] => node['core']['deployers']['gems']
    }
  }

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

node.set['ruby_build']['upgrade'] = 'sync'
node.set['rbenv']['upgrade'] = 'sync'

include_recipe 'ruby_build::default'
include_recipe 'rbenv::user'

node['core']['deployments'].each do |deployment|
  core_deployment deployment[:name] do
    apps lazy {
      if deployment[:apps]
        deployment[:apps].map { |a| resources("core_#{a[:type]}_app[#{a[:name]}]") }
      else
        []
      end
    }
    action deployment[:action] if deployment[:action]
  end
end
