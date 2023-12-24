class User < ApplicationRecord
  belongs_to :favorite_state, class_name: :State, optional: true
  belongs_to :home_state, class_name: :State, optional: true

  validates_associated :favorite_state, :home_state

  accepts_nested_attributes_for :favorite_state, :home_state
end
