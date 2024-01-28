class Movie < ApplicationRecord
  default_scope { alphabetically }

  scope :search, ->(q) { q.blank? ? all : where("title LIKE ?", "#{q}%") }

  scope :alphabetically, -> { order(:title) }

  def to_combobox_display
    title
  end
end
