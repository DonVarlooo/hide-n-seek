class Game < ApplicationRecord
  after_validation :set_radius
  validates :duration, presence: true
  reverse_geocoded_by :lat, :lng
  before_save :geocode, if: :will_save_change_to_lng?

  private

  def set_radius
    self.radius = 500
  end
end
