#
# Cookbook Name:: core
# Recipe:: services
#

include_recipe 'core::_common_system' if node['core']['common_system']

node['core']['services'].each do |service|
  core_service service[:name] do
    action service[:action] if service[:action]
  end
end
