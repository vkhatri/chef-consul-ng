require 'chef/resource'
# http://www.consul.io/docs/agent/watches.html

class Chef
  class Resource
    # provides consul_watch
    class ConsulWatch < Chef::Resource
      identity_attr :name

      def initialize(name, run_context = nil)
        super
        @resource_name = :consul_watch
        @provides = :consul_watch
        @provider = Chef::Provider::ConsulWatch
        @action = :create
        @allowed_actions = %i[create delete nothing]
        @name = name
      end

      def type(arg = nil)
        set_or_return(
          :type, arg,
          :kind_of => String,
          :equal_to => %w[checks event key keyprefix nodes service services],
          :default => nil
        )
      end

      def prefix(arg = nil)
        set_or_return(
          :prefix, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def key(arg = nil)
        set_or_return(
          :key, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def args(arg = nil)
        set_or_return(
          :args, arg,
          :kind_of => Array,
          :default => nil
        )
      end

      def handler_type(arg = nil)
        set_or_return(
          :handler_type, arg,
          :kind_of => String,
          :equal_to => %w[script http],
          :default => nil
        )
      end

      def http_handler_config(arg = nil)
        set_or_return(
          :http_handler_config, arg,
          :kind_of => Hash,
          :default => nil
        )
      end

      def handler(arg = nil)
        set_or_return(
          :handler, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def datacenter(arg = nil)
        set_or_return(
          :datacenter, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def token(arg = nil)
        set_or_return(
          :token, arg,
          :kind_of => String,
          :default => nil
        )
      end
    end
  end
end
