require 'chef/resource'

class Chef
  class Resource
    # provides consul_acl
    class ConsulAcl < Chef::Resource
      identity_attr :name

      def initialize(name, run_context = nil)
        super
        @resource_name = :consul_acl
        @provides = :consul_acl
        @provider = Chef::Provider::ConsulAcl
        @action = :create
        @allowed_actions = %i[create delete nothing]
        @name = name
      end

      def url(arg = nil)
        set_or_return(
          :url, arg,
          :kind_of => String,
          :default => 'http://localhost:8500'
        )
      end

      def acl(arg = nil)
        set_or_return(
          :acl, arg,
          :kind_of => String,
          :default => name
        )
      end

      def type(arg = nil)
        set_or_return(
          :type, arg,
          :kind_of => String,
          :equal_to => %w[client management],
          :default => 'client'
        )
      end

      def id(arg = nil)
        set_or_return(
          :id, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def rules(arg = nil)
        set_or_return(
          :rules, arg,
          :kind_of => [String, Hash],
          :default => nil
        )
      end

      def token(arg = nil)
        set_or_return(
          :token, arg,
          :kind_of => String,
          :required => true,
          :default => nil
        )
      end
    end
  end
end
