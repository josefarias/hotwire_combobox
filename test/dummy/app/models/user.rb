class User < ApplicationRecord
  belongs_to :favorite_state, class_name: :State, optional: true
  belongs_to :home_state, class_name: :State, optional: true

  accepts_nested_attributes_for :favorite_state, :home_state
end
