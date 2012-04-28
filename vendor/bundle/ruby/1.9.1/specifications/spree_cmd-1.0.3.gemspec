# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "spree_cmd"
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Chris Mar"]
  s.date = "2012-03-16"
  s.description = "tools to create new Spree stores and extensions"
  s.email = ["chris@spreecommerce.com"]
  s.executables = ["spree", "spree_cmd"]
  s.files = ["bin/spree", "bin/spree_cmd"]
  s.homepage = "http://spreecommerce.com"
  s.require_paths = ["lib"]
  s.rubyforge_project = "spree_cmd"
  s.rubygems_version = "1.8.21"
  s.summary = "Spree Commerce command line utility"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
