require_relative "lib/combobox/version"

Gem::Specification.new do |spec|
  spec.name        = "hotwire_combobox"
  spec.version     = Combobox::VERSION
  spec.authors     = ["Jose Farias"]
  spec.email       = ["jose@farias.mx"]
  spec.homepage    = "https://jose.omg.lol/"
  spec.summary     = "A combobox implementation for Ruby on Rails."
  spec.description = "A combobox implementation for Ruby on Rails."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/josefarias/combobox"
  spec.metadata["changelog_uri"] = "https://github.com/josefarias/combobox"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.7.2"
end
