#
# Cookbook Name:: otr
# Resource:: deployment
#

=begin
#<
@action create creates the deployment.
@action delete deletes the deployment.

@attribute name the name of the deployment.
@attribute apps the apps this deployment will deploy to,
@attribute server_group the group name the server runs as that will use the deployment.
#>
=end

default_action :create

actions :create, :delete

attribute :name, kind_of: String, required: true, name_attribute: true
attribute :apps, kind_of: Array, default: []
attribute :server_group, kind_of: String
