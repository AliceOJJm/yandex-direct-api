# -*- encoding: utf-8 -*-
# stub: yandex-direct-api 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "yandex-direct-api"
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["AliceO"]
  s.date = "2016-07-21"
  s.description = "Gem for interaction with Yandex Direct API version 5"
  s.email = "aliceo.jjm@gmail.com"
  s.files = ["Rakefile", "lib/yandex-direct-api.rb"]
  s.homepage = "https://github.com/aliceojjm/yandex-direct-api"
  s.rubygems_version = "2.5.1"
  s.summary = "Gem for interaction with Yandex Direct API version 5"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 1.13"])
      s.add_development_dependency(%q<rake>, [">= 11.2.2"])
      s.add_development_dependency(%q<rspec>, [">= 3.5.0"])
    else
      s.add_dependency(%q<bundler>, [">= 1.13"])
      s.add_dependency(%q<rake>, [">= 11.2.2"])
      s.add_dependency(%q<rspec>, [">= 3.5.0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 1.13"])
    s.add_dependency(%q<rake>, [">= 11.2.2"])
    s.add_dependency(%q<rspec>, [">= 3.5.0"])
  end
end
