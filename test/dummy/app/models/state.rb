class State < ApplicationRecord
  default_scope { alphabetically }

  scope :alphabetically, -> { order(:name) }

  def to_combobox_display
    name
  end
end
