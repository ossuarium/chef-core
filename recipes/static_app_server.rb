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

logrotate_app 'nginx-server-blocks' do
  path "#{default['nginx']['log_dir']}/*.log"
end

node['core']['apps'].select { |_, v| v[:type] == 'static' }.each do |app, params|
  core_static_app app do
    moniker params[:moniker]
    service resources(core_service: params[:service])
    storage params[:storage] if params[:storage]
    action params[:action] if params[:action]
  end
end
