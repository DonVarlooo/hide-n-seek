class UserGameChannel < ApplicationCable::Channel
  def subscribed
    user_game = UserGame.find_by(game: game, user: self)
    stream_for user_game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
