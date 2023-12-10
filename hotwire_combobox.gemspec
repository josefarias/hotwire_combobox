require_relative "lib/hotwire_combobox/version"

Gem::Specification.new do |spec|
  spec.name        = "hotwire_combobox"
  spec.version     = HotwireCombobox::VERSION
  spec.authors     = ["Jose Farias"]
  spec.email       = ["jose@farias.mx"]
  spec.homepage    = "https://github.com/josefarias/hotwire_combobox"
  spec.summary     = "A combobox implementation for Ruby on Rails apps running on Hotwire"
  spec.description = "A combobox implementation for Ruby on Rails apps running on Hotwire."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/josefarias/hotwire_combobox"
  spec.metadata["changelog_uri"] = "https://github.com/josefarias/hotwire_combobox"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.7.2"
  spec.add_dependency "importmap-rails", ">= 1.2"
  spec.add_dependency "stimulus-rails", ">= 1.2"
end
