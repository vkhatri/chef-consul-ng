require 'chef/resource'

class Chef
  class Resource
    # provides consul_check
    class ConsulCheck < Chef::Resource
      identity_attr :name

      def initialize(name, run_context = nil)
        super
        @resource_name = :consul_check
        @provides = :consul_check
        @provider = Chef::Provider::ConsulCheck
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

      def script(arg = nil)
        set_or_return(
          :script, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def http(arg = nil)
        set_or_return(
          :http, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def tcp(arg = nil)
        set_or_return(
          :tcp, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def docker_container_id(arg = nil)
        set_or_return(
          :docker_container_id, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def shell(arg = nil)
        set_or_return(
          :shell, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def timeout(arg = nil)
        set_or_return(
          :timeout, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def interval(arg = nil)
        set_or_return(
          :interval, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def ttl(arg = nil)
        set_or_return(
          :ttl, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def service_id(arg = nil)
        set_or_return(
          :service_id, arg,
          :kind_of => String,
          :default => nil
        )
      end
    end
  end
end
