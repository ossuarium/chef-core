#
# Cookbook Name:: core
# Recipe:: static_app_server
#

node.default['core']['servers']['http'] = true
node.default['core']['servers']['https'] = true

include_recipe 'core::_common_system' if node['core']['common_system']
include_recipe 'nfs::client4'
include_recipe 'core::_nginx_server'
include_recipe 'core::services'

node['core']['apps'].select { |a| a[:type] == 'static' }.each do |app|
  core_static_app app[:name] do
    moniker app[:moniker]
    service resources(core_service: app[:service])
    action app[:action] if app[:action]
  end
end
