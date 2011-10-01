# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{quote-extractor}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3") if s.respond_to? :required_rubygems_version=
  s.authors = ["Andrey Sidorov"]
  s.date = %q{2011-10-01}
  s.email = %q{takandar@gmail.com}
  s.files = ["Rakefile", "Guardfile", "lib/quote_extractor.rb"]
  s.homepage = %q{https://github.com/morr/QuoteExtractor}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Extractor for quotes in text}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
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
