require 'ipaddr'

class Chef
  class Recipe
    # Utility methods for private network info.
    class PrivateNetwork
      attr_accessor :node

      def initialize(node)
        @node = node
      end

      # @return [Hash] the node attributes for the private interface
      def interface
        node['network']['interfaces'][node['core']['private_interface']]
      end

      # @return [String] the node's private IP address
      def ip
        interface['addresses'].find { |_, v| v['family'] == 'inet' }.first
      end

      # @return [String] the node's netmask for the private network
      def netmask
        interface['addresses'][ip]['netmask']
      end

      # @return [String] the node's network in the form `10.0.0.0/255.255.255.0`
      def subnet
        ipaddr = IPAddr.new "#{ip}/#{netmask}"
        "#{ipaddr}/#{netmask}"
      end
    end
  end
end
