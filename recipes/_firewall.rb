#
# Cookbook Name:: otr
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
  action [:allow]
  notifies :enable, 'firewall[ufw]'
end

# This is required to enable rate limiting for ssh.
# @todo Replace this when [COOK-4734] is closed.
# [COOK-4734]: https://tickets.opscode.com/browse/COOK-4734
execute 'ufw limit ssh/tcp' do
  action :run
  not_if 'ufw status | grep LIMIT'
end
