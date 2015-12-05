if defined?(ChefSpec)
  ChefSpec.define_matcher(:consul_service)

  def create_consul_service(service)
    ChefSpec::Matchers::ResourceMatcher.new(:consul_service, :create, service)
  end

  def delete_consul_service(service)
    ChefSpec::Matchers::ResourceMatcher.new(:consul_service, :delete, service)
  end
end
