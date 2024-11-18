require "hotwire_combobox/version"
require "hotwire_combobox/engine"
require "hotwire_combobox/platform"

module HotwireCombobox
  mattr_accessor :bypass_convenience_methods
  @@bypass_convenience_methods = false

  class << self
    def setup
      yield self
    end

    def bypass_convenience_methods?
      bypass_convenience_methods
    end

    def stylesheet_path
      "hotwire_combobox"
    end
  end
end
