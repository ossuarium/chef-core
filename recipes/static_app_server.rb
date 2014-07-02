#
# Cookbook Name:: otr
# Recipe:: static_app_server
#

include_recipe 'otr::_common_system'
include_recipe 'nginx::default'
include_recipe 'otr::services'

node['otr']['apps'].select { |a| a[:type] == 'static' }.each do |app|
  otr_static_app app[:name] do
    moniker app[:moniker]
    service resources(otr_service: app[:service])
    action app[:action] if app[:action]
  end
end

include_recipe 'otr::deployment'
