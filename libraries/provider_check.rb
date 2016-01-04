class Chef
  class Provider
    # provides consul_check
    class ConsulCheck < Chef::Provider
      provides :consul_check if respond_to?(:provides)

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
        content['id'] = new_resource.id if new_resource.id
        content['script'] = new_resource.script if new_resource.script
        content['http'] = new_resource.http if new_resource.http
        content['tcp'] = new_resource.tcp if new_resource.tcp
        content['ttl'] = new_resource.ttl if new_resource.ttl
        content['docker_container_id'] = new_resource.docker_container_id if new_resource.docker_container_id
        content['shell'] = new_resource.shell if new_resource.shell
        content['timeout'] = new_resource.timeout if new_resource.timeout
        content['interval'] = new_resource.interval if new_resource.interval
        content['service_id'] = new_resource.service_id if new_resource.service_id

        t = Chef::Resource::File.new("consul_check_#{new_resource.name}", run_context)
        t.path ::File.join(node['consul']['conf_dir'], "101-check-#{new_resource.name}.json")
        t.content JSON.pretty_generate(check: content)
        t.notifies :reload, 'service[consul]' if notify_service_restart?
        t.run_action action
        t.updated?
      end
    end
  end
end
