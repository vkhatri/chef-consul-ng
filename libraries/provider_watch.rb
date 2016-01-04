class Chef
  class Provider
    # provides consul_watch
    class ConsulWatch < Chef::Provider
      provides :consul_watch if respond_to?(:provides)

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
        new_resource.updated_by_last_action(check_file)
      end

      def action_delete
        new_resource.updated_by_last_action(check_file)
      end

      protected

      def check_file
        action = new_resource.action.is_a?(Array) ? new_resource.action.first : new_resource.action
        content = { 'name' => new_resource.name }
        content['type'] = new_resource.type
        content['prefix'] = new_resource.prefix if new_resource.prefix
        content['handler'] = new_resource.handler if new_resource.handler
        content['datacenter'] = new_resource.datacenter if new_resource.datacenter
        content['token'] = new_resource.token if new_resource.token

        t = Chef::Resource::File.new("consul_watch_#{new_resource.name}", run_context)
        t.path ::File.join(node['consul']['conf_dir'], "102-watch-#{new_resource.name}.json")
        t.content JSON.pretty_generate(watches: [content])
        t.notifies :reload, 'service[consul]' if notify_service_restart?
        t.run_action action
        t.updated?
      end
    end
  end
end
