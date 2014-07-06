#
# Cookbook Name:: core
# Recipe:: _firewall
#

include_recipe 'firewall::default'

#
# Enable firewall and allow ssh.
#

firewall 'ufw' do
  action :nothing
end

firewall_rule 'ssh' do
  port 22
  action :allow
  notifies :enable, 'firewall[ufw]'
end

# This is required to enable rate limiting for ssh.
# @todo Replace this when [COOK-4734] is closed.
# [COOK-4734]: https://tickets.opscode.com/browse/COOK-4734
execute 'ufw limit ssh/tcp' do
  action :run
  not_if 'ufw status | grep LIMIT'
end

#
# Open ports based on enabled servers.
#

firewall_rule 'http' do
  protocol :tcp
  port 80
  action node['core']['servers']['http'] ? :allow : :reject
end

firewall_rule 'https' do
  protocol :tcp
  port 443
  action node['core']['servers']['https'] ? :allow : :reject
end

firewall_rule 'mysql' do
  protocol :tcp
  port node['mysql']['port'].to_i
  action node['core']['servers']['mysql'] ? :allow : :reject
end

firewall_rule 'nfs' do
  protocol :tcp
  ports [
    node['nfs']['port']['statd'],
    node['nfs']['port']['statd_out'],
    node['nfs']['port']['mountd'],
    node['nfs']['port']['lockd'],
    node['nfs']['port']['rquotad']
  ]
  action node['core']['servers']['nfs'] ? :allow : :reject
end
