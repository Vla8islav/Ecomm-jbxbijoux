# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spree"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sean Schofield"]
  s.date = "2012-03-16"
  s.description = "Spree is an open source e-commerce framework for Ruby on Rails.  Join us on the spree-user google group or in #spree on IRC"
  s.email = "sean@spreecommerce.com"
  s.homepage = "http://spreecommerce.com"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = ["none"]
  s.rubygems_version = "1.8.21"
  s.summary = "Full-stack e-commerce framework for Ruby on Rails."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["= 1.0.3"])
      s.add_runtime_dependency(%q<spree_auth>, ["= 1.0.3"])
      s.add_runtime_dependency(%q<spree_api>, ["= 1.0.3"])
      s.add_runtime_dependency(%q<spree_dash>, ["= 1.0.3"])
      s.add_runtime_dependency(%q<spree_sample>, ["= 1.0.3"])
      s.add_runtime_dependency(%q<spree_promo>, ["= 1.0.3"])
      s.add_runtime_dependency(%q<spree_cmd>, ["= 1.0.3"])
    else
      s.add_dependency(%q<spree_core>, ["= 1.0.3"])
      s.add_dependency(%q<spree_auth>, ["= 1.0.3"])
      s.add_dependency(%q<spree_api>, ["= 1.0.3"])
      s.add_dependency(%q<spree_dash>, ["= 1.0.3"])
      s.add_dependency(%q<spree_sample>, ["= 1.0.3"])
      s.add_dependency(%q<spree_promo>, ["= 1.0.3"])
      s.add_dependency(%q<spree_cmd>, ["= 1.0.3"])
    end
  else
    s.add_dependency(%q<spree_core>, ["= 1.0.3"])
    s.add_dependency(%q<spree_auth>, ["= 1.0.3"])
    s.add_dependency(%q<spree_api>, ["= 1.0.3"])
    s.add_dependency(%q<spree_dash>, ["= 1.0.3"])
    s.add_dependency(%q<spree_sample>, ["= 1.0.3"])
    s.add_dependency(%q<spree_promo>, ["= 1.0.3"])
    s.add_dependency(%q<spree_cmd>, ["= 1.0.3"])
  end
end
