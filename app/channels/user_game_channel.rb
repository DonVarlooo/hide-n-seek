class UserGameChannel < ApplicationCable::Channel
  def subscribed
    user_game = UserGame.find(params[:id])
    stream_for user_game
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
