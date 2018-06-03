class Chef
  class Provider
    # provides consul_acl
    class ConsulAcl < Chef::Provider
      provides :consul_acl if respond_to?(:provides)

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
        check_acl
      end

      def action_delete
        check_acl
      end

      protected

      def check_acl
        require 'diplomat'

        Diplomat.configure do |config|
          config.url = new_resource.url
          config.acl_token = new_resource.token
          config.options = { request: { timeout: 30 } }
        end

        case new_resource.action
        when 'delete', :delete, [:delete]
          delete_acl
        when 'create', :create, [:create]
          create_acl
        end
      end

      def check_current_acl
        filter_keys = %w(Name ID Type Rules)
        current = Diplomat::Acl.info(new_resource.id).first
        if current.nil?
          return nil
        else
          current.select! { |k| filter_keys.include?(k) }
          current
        end
      end

      def acl_payload_string
        { 'ID' => new_resource.id, 'Name' => new_resource.acl, 'Type' => new_resource.type, 'Rules' => new_resource.rules }
      end

      def acl_payload_json
        { 'ID' => new_resource.id, 'Name' => new_resource.acl, 'Type' => new_resource.type, 'Rules' => JSON.pretty_generate(new_resource.rules) }
      end

      def acl_payload_string?
        new_resource.rules.is_a?(String) ? true : false
      end

      def create_acl
        current_acl = check_current_acl
        acl_payload = acl_payload_string? ? acl_payload_string : acl_payload_json

        if current_acl.nil?
          Diplomat::Acl.create(acl_payload)
          return true
        elsif acl_payload_string?
          # enforce supplied rules, string forms HCL string
          if current_acl['Rules'] != acl_payload['Rules']
            Diplomat::Acl.update(acl_payload)
            return true
          else
            return false
          end
        else
          # enforce supplied rules, hash forms json
          begin
            # expecting existing rules to be JSON
            current_rules = JSON.parse(current_acl['Rules'])
            diff = (new_resource.rules.to_a - current_rules.to_a)
            if diff.empty?
              return false
            else
              Diplomat::Acl.update(acl_payload)
              return true
            end
          rescue => error
            # if encounter an error in JSON.parse exisitng rules,
            # simply update with new acl
            Diplomat::Acl.update(acl_payload)
            Chef::Log.warning("consul_acl[#{new_resource.name}] existing Rules were overwritten with new Rules, encountered error (#{error})")
            return true
          end
        end
      end

      def delete_acl
        current_acl = check_current_acl
        if current_acl.nil?
          return false
        else
          Diplomat::Acl.destroy(new_resource.id)
          return true
        end
      end
    end
  end
end
