class State < ApplicationRecord
  default_scope { alphabetically }

  enum :location, %i[ South West Northeast Midwest ]

  scope :alphabetically, -> { order(:name) }

  def to_combobox_display
    name
  end
end
