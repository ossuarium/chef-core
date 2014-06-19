#
# Cookbook Name:: otr
# Recipe:: _common_system
#

include_recipe 'annoyances::default'
include_recipe 'chef-sugar::default'
include_recipe 'otr::_users'
include_recipe 'apt::default' if debian?
include_recipe 'ntp::default'
include_recipe 'timezone-ii::default'
include_recipe 'zsh::default'
include_recipe 'vim::default'
include_recipe 'sudo::default'
include_recipe 'openssh::default'
include_recipe 'otr::_firewall'
include_recipe 'oh-my-zsh::default'
