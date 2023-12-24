class State < ApplicationRecord
  default_scope { alphabetically }

  scope :alphabetically, -> { order(:name) }

  validates_presence_of :name
end
