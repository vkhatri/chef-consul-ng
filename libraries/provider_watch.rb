class Chef
  class Provider
    # provides consul_watch
    class ConsulWatch < Chef::Provider
      provides :consul_watch if respond_to?(:provides)

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
        check_file
      end

      def action_delete
        check_file
      end

      protected

      def check_file
        action = new_resource.action.is_a?(Array) ? new_resource.action.first : new_resource.action
        content = { 'type' => new_resource.type }
        content['prefix'] = new_resource.prefix if new_resource.prefix
        content['handler'] = new_resource.handler if new_resource.handler
        content['key'] = new_resource.key if new_resource.key
        content['args'] = new_resource.args if new_resource.args
        content['handler_type'] = new_resource.handler_type if new_resource.handler_type
        content['http_handler_config'] = new_resource.http_handler_config if new_resource.http_handler_config
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
