require "hotwire_combobox/version"
require "hotwire_combobox/engine"

module HotwireCombobox
  Option = Struct.new(:id, :value, :display, :content, :filterable_as, :autocompletable_as)

  mattr_accessor :bypass_convenience_methods
  @@bypass_convenience_methods = false

  class << self
    def setup
      yield self
    end

    def bypass_convenience_methods?
      bypass_convenience_methods
    end
  end
end
