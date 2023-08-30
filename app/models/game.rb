class Game < ApplicationRecord
  after_validation :set_radius
  validates :duration, presence: true
  before_save :geocode, if: :will_save_change_to_lng?
  reverse_geocoded_by :lat, :lng

  # geocoded_by :lat
  # geocoded_by :lng
  # after_validation :geocode, if: :will_save_change_to_lat?
  # after_validation :geocode, if: :will_save_change_to_lng?

  private

  def set_radius
    self.radius = 500
  end
end
