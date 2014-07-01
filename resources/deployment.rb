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
#>
=end

default_action :create

actions :create, :delete

attribute :name, kind_of: String, required: true, name_attribute: true
attribute :apps, kind_of: Array, default: []
