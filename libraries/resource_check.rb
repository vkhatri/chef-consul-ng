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
        @allowed_actions = %i[create delete nothing]
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

      def notes(arg = nil)
        set_or_return(
          :notes, arg,
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

      def initial_status(arg = nil)
        set_or_return(
          :initial_status, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def grpc(arg = nil)
        set_or_return(
          :grpc, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def grpc_use_tls(arg = nil)
        set_or_return(
          :grpc_use_tls, arg,
          :kind_of => [TrueClass, FalseClass],
          :default => nil
        )
      end

      def tls_skip_verify(arg = nil)
        set_or_return(
          :tls_skip_verify, arg,
          :kind_of => [TrueClass, FalseClass],
          :default => nil
        )
      end

      def method(arg = nil)
        set_or_return(
          :method, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def header(arg = nil)
        set_or_return(
          :header, arg,
          :kind_of => Hash,
          :default => nil
        )
      end
    end
  end
end
