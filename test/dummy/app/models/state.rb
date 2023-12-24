class State < ApplicationRecord
  default_scope { alphabetically }

  scope :alphabetically, -> { order(:name) }
end
