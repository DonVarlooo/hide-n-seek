class Game < ApplicationRecord
  after_validation :set_radius
  validates :duration, presence: true

  private

  def set_radius
    self.radius = 500
  end
end
