class Game < ApplicationRecord
  after_validation :set_radius
  validates :duration, presence: true
  before_save :geocode, if: :will_save_change_to_lng?
  reverse_geocoded_by :lat, :lng
  enum :status, { pending: 0, ongoing: 1, finished: 2 }
  belongs_to :user
  has_many :users, through: :user_game
  has_many :user_games
  has_many :messages, dependent: :destroy
  
  private

  DURATION = ["10 minutes", "15 minutes", "20 minutes", "30 minutes"]
  MODE = ["1v1", "Multiplayer", "Royal Rumble", "Zombie"]

  def set_radius
    self.radius = 500
  end
end
