#
# Cookbook Name:: otr
# Resource:: service
#

=begin
#<
A service is the top-level organizational unit for providing web services.
Each service will have its own directory under `node['otr']['srv_dir']`
and a corresponding configuration directory for the installed web server.

A set of default directories to create for each service under its
primary directory is set in `node['otr']['service']['dirs']`.

@action create Creates the service.
@action delete Deletes the service.
#>
=end

default_action :create

actions :create, :delete

#<> @attribute name The name of the service.
attribute :name, kind_of: String, required: true, name_attribute: true

attr_accessor :dir, :apache_conf_dir
