require 'chef/resource'

class Chef
  class Resource
    # provides consul_service
    class ConsulService < Chef::Resource
      identity_attr :name

      def initialize(name, run_context = nil)
        super
        @resource_name = :consul_service
        @provides = :consul_service
        @provider = Chef::Provider::ConsulService
        @action = :create
        @allowed_actions = [:create, :delete, :nothing]
        @name = name
      end

      def id(arg = nil)
        set_or_return(
          :id, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def tags(arg = nil)
        set_or_return(
          :tags, arg,
          :kind_of => Array,
          :default => []
        )
      end

      def address(arg = nil)
        set_or_return(
          :address, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def port(arg = nil)
        set_or_return(
          :port, arg,
          :kind_of => Integer,
          :default => nil
        )
      end

      def checks(arg = nil)
        set_or_return(
          :checks, arg,
          :kind_of => Array,
          :default => nil
        )
      end
    end
  end
end
