require_relative "lib/hotwire_combobox/version"

Gem::Specification.new do |spec|
  spec.name = "hotwire_combobox"
  spec.version = HotwireCombobox::VERSION
  spec.authors = [ "Jose Farias" ]
  spec.email = [ "jose@farias.mx" ]
  spec.homepage = "https://hotwirecombobox.com/"
  spec.summary = "Accessible Autocomplete for Rails apps"
  spec.description = "An accessible autocomplete for Ruby on Rails apps using Hotwire."
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/josefarias/hotwire_combobox"
  spec.metadata["changelog_uri"] = "https://github.com/josefarias/hotwire_combobox/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.7.2"
  spec.add_dependency "stimulus-rails", ">= 1.2"
  spec.add_dependency "turbo-rails", ">= 1.2"

  spec.add_development_dependency "mocha", "~> 2.1"
end
