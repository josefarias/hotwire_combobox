require "combobox/version"
require "combobox/engine"

module Combobox
  Option = Struct.new(:id, :value, :content, :filterable_as, :autocompletable_as)
end
