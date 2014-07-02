#
# Cookbook Name:: otr
# Recipe:: services
#

node['otr']['services'].each do |service|
  otr_service service[:name] do
    action service[:action] if service[:action]
  end
end
