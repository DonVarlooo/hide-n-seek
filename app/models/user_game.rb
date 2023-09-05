class UserGame < ApplicationRecord
  belongs_to :user
  belongs_to :game

  has_one_attached :photo

  def win_streak(arr)
    current_streak = 0

    arr.each do |value|
      if value
        current_streak += 1
      else
        current_streak = 0
      end
    end

    max_streak
  end
end
