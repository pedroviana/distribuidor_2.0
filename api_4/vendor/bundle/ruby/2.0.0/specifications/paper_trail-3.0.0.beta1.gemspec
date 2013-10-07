# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "paper_trail"
  s.version = "3.0.0.beta1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andy Stewart", "Ben Atkins"]
  s.date = "2013-08-30"
  s.description = "Track changes to your models' data.  Good for auditing or versioning."
  s.email = "boss@airbladesoftware.com"
  s.homepage = "http://github.com/airblade/paper_trail"
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.3"
  s.summary = "Track changes to your models' data.  Good for auditing or versioning."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["< 5.0", ">= 3.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_development_dependency(%q<ffaker>, [">= 1.15"])
      s.add_development_dependency(%q<railties>, ["< 5.0", ">= 3.0"])
      s.add_development_dependency(%q<sinatra>, ["~> 1.0"])
      s.add_development_dependency(%q<rack-test>, [">= 0.6"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.2"])
    else
      s.add_dependency(%q<activerecord>, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_dependency(%q<ffaker>, [">= 1.15"])
      s.add_dependency(%q<railties>, ["< 5.0", ">= 3.0"])
      s.add_dependency(%q<sinatra>, ["~> 1.0"])
      s.add_dependency(%q<rack-test>, [">= 0.6"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
      s.add_dependency(%q<sqlite3>, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<activerecord>, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<shoulda>, ["~> 3.5"])
    s.add_dependency(%q<ffaker>, [">= 1.15"])
    s.add_dependency(%q<railties>, ["< 5.0", ">= 3.0"])
    s.add_dependency(%q<sinatra>, ["~> 1.0"])
    s.add_dependency(%q<rack-test>, [">= 0.6"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.14"])
    s.add_dependency(%q<sqlite3>, ["~> 1.2"])
  end
end
