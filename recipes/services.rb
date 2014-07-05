#
# Cookbook Name:: core
# Recipe:: services
#

node['core']['services'].each do |service|
  core_service service[:name] do
    action service[:action] if service[:action]
  end
end
