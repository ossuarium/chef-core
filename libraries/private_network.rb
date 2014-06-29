require 'ipaddr'

class Chef
  class Recipe
    # Utility methods for private network info.
    class PrivateNetwork
      attr_accessor :node

      def initialize(node)
        @node = node
      end

      def interface
        node['network']['interfaces'][node['otr']['private_interface']]
      end

      def ip
        interface['addresses'].find { |_, v| v['family'] == 'inet' }.first
      end

      def netmask
        interface['addresses'][ip]['netmask']
      end

      def subnet
        ipaddr = IPAddr.new "#{ip}/#{netmask}"
        "#{ipaddr}/#{netmask}"
      end
    end
  end
end
