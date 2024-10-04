class Movie < ApplicationRecord
  default_scope { alphabetically }

  enum :rating, %w[ G PG PG-13 R NC-17 ]

  scope :search, ->(q) { q.blank? ? all : where("title LIKE ?", "#{q}%") }
  scope :full_search, ->(q) { q.blank? ? all : where("title LIKE ?", "%#{q}%") }
  scope :alphabetically, -> { order(:title) }

  def to_combobox_display
    title
  end
end
