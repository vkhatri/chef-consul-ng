class Chef
  class Provider
    # provides consul_script
    class ConsulScript < Chef::Provider
      provides :consul_script if respond_to?(:provides)

      use_inline_resources
      
      def initialize(*args)
        super
      end

      def whyrun_supported?
        true
      end

      def load_current_resource
        true
      end

      def action_create
        script_file
      end

      def action_delete
        script_file
      end

      protected

      def script_file
        action = new_resource.action.is_a?(Array) ? new_resource.action.first : new_resource.action
        if new_resource.script_content
          t = Chef::Resource::File.new("consul_script_#{new_resource.name}", run_context)
          t.content new_resource.script_content
        elsif new_resource.cookbook_file
          t = Chef::Resource::CookbookFile.new("consul_script_#{new_resource.name}", run_context)
          t.source new_resource.cookbook_file if new_resource.cookbook_file
          t.cookbook new_resource.cookbook if new_resource.cookbook
        elsif new_resource.cookbook_template
          t = Chef::Resource::Template.new("consul_script_#{new_resource.name}", run_context)
          t.source new_resource.cookbook_template if new_resource.cookbook_template
          t.variables new_resource.template_variables if new_resource.template_variables
          t.cookbook new_resource.cookbook if new_resource.cookbook
        else
          raise 'must define one of resource attribute - :script_content, :cookbook_template or :cookbook_file'
        end
        t.path ::File.join(node['consul']['scripts_dir'], new_resource.name)
        t.mode 0o0755
        t.run_action action
        t.updated?
      end
    end
  end
end
