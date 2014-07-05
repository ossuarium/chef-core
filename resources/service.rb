#
# Cookbook Name:: core
# Resource:: service
#

=begin
#<
A service is the top-level organizational unit for providing web services.
Each service will have its own directory under `node['core']['srv_dir']`
and a corresponding configuration directory for the installed web server.

A set of default directories to create for each service under its
primary directory is set in `node['core']['service']['dirs']`.

@action create creates the service.
@action delete deletes the service.

@attribute name the name of the service.
#>
=end

default_action :create

actions :create, :delete

attribute :name, kind_of: String, required: true, name_attribute: true

attr_accessor :dir, :nginx_conf_dir, :apache_conf_dir
