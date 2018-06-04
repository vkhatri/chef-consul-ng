class Chef
  class Provider
    # provides consul_check
    class ConsulCheck < Chef::Provider
      provides :consul_check if respond_to?(:provides)

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
        content['notes'] = new_resource.notes if new_resource.notes
        content['args'] = new_resource.args if new_resource.args
        content['initial_status'] = new_resource.initial_status if new_resource.initial_status
        content['grpc'] = new_resource.grpc if new_resource.grpc
        content['grpc_use_tls'] = new_resource.grpc_use_tls if new_resource.grpc_use_tls
        content['tls_skip_verify'] = new_resource.tls_skip_verify if new_resource.tls_skip_verify
        content['method'] = new_resource.tls_skip_verify if new_resource.tls_skip_verify
        content['header'] = new_resource.header if new_resource.header

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
