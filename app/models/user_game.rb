class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_one_attached :photo

end
