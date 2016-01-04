class Chef
  class Provider
    # provides consul_service
    class ConsulService < Chef::Provider
      provides :consul_service if respond_to?(:provides)

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
        new_resource.updated_by_last_action(service_file)
      end

      def action_delete
        new_resource.updated_by_last_action(service_file)
      end

      protected

      def service_file
        action = new_resource.action.is_a?(Array) ? new_resource.action.first : new_resource.action
        content = { 'name' => new_resource.name }
        content['id'] = new_resource.id if new_resource.id
        content['tags'] = new_resource.tags if new_resource.tags
        content['address'] = new_resource.address if new_resource.address
        content['port'] = new_resource.port if new_resource.port
        content['enableTagOverride'] = new_resource.enable_tag_override unless new_resource.enable_tag_override.nil?
        content['checks'] = new_resource.checks if new_resource.checks
        content['token'] = new_resource.token if new_resource.token

        t = Chef::Resource::File.new("consul_service_#{new_resource.name}", run_context)
        t.path ::File.join(node['consul']['conf_dir'], "100-service-#{new_resource.name}.json")
        t.content JSON.pretty_generate(service: content)
        t.notifies :reload, 'service[consul]' if notify_service_restart?
        t.run_action action
        t.updated?
      end
    end
  end
end
