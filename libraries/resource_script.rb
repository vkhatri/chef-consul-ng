require 'chef/resource'

class Chef
  class Resource
    # provides consul_script
    class ConsulScript < Chef::Resource
      identity_attr :name

      def initialize(name, run_context = nil)
        super
        @resource_name = :consul_script
        @provides = :consul_script
        @provider = Chef::Provider::ConsulScript
        @action = :create
        @allowed_actions = [:create, :delete, :nothing]
        @name = name
      end

      def cookbook_template(arg = nil)
        set_or_return(
          :cookbook_template, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def cookbook_file(arg = nil)
        set_or_return(
          :cookbook_file, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def cookbook(arg = nil)
        set_or_return(
          :cookbook, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def script_content(arg = nil)
        set_or_return(
          :script_content, arg,
          :kind_of => String,
          :default => nil
        )
      end

      def template_variables(arg = nil)
        set_or_return(
          :template_variables, arg,
          :kind_of => Hash,
          :default => nil
        )
      end
    end
  end
end
