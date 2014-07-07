#
# Cookbook Name:: core
# Recipe:: services
#

include_recipe 'core::_common_system' if node['core']['common_system']

node['core']['services'].each do |service, params|
  core_service service do
    action params[:action] if params[:action]
  end
end
