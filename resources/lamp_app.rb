#
# Cookbook Name:: otr
# Resource:: lamp_app
#

default_action :create

actions :create, :delete

attribute :name, kind_of: String, required: true, name_attribute: true
attribute :moniker, kind_of: String, required: true
attribute :service, kind_of: Chef::Resource, required: true
attribute :fpm_socket, kind_of: String
attribute :mysql_connection, kind_of: Hash, default: {}
attribute :db_name, kind_of: String
attribute :db_user, kind_of: String
attribute :db_password, kind_of: String
attribute :db_client, kind_of: String, default: '%'

attr_accessor :fpm_socket, :db_name, :db_user, :db_password, :dir, :conf_dir, :fpm_socket_path
