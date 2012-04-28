# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spree_usa_epay"
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Mar"]
  s.date = "2012-02-24"
  s.description = "Payment Method for USA ePay SOAP Webservice"
  s.email = "support@spreecommerce.com"
  s.homepage = "https://github.com/spree/spree_usa_epay"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = ["none"]
  s.rubygems_version = "1.8.21"
  s.summary = "Spree Payment Gateway for USA ePay"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, [">= 1.0.0"])
      s.add_runtime_dependency(%q<savon>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
    else
      s.add_dependency(%q<spree_core>, [">= 1.0.0"])
      s.add_dependency(%q<savon>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
    end
  else
    s.add_dependency(%q<spree_core>, [">= 1.0.0"])
    s.add_dependency(%q<savon>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
  end
end
