class User < ApplicationRecord
  belongs_to :favorite_state, class_name: :State, optional: true
  belongs_to :home_state, class_name: :State, optional: true

  has_many :visits
  has_many :visited_states, through: :visits, source: :state

  accepts_nested_attributes_for :favorite_state, :home_state
end
