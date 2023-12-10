require "hotwire_combobox/version"
require "hotwire_combobox/engine"

module HotwireCombobox
  Option = Struct.new(:id, :value, :display, :content, :filterable_as, :autocompletable_as)
end
