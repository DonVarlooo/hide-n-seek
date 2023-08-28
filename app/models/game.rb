class Game < ApplicationRecord
  def index
    @games = Game.all
  end

  def create
  @game = Game.new(game_params)
  @game.user = current_user

  end

  private

  def game_params
    params.require(:game).permit(:lat, :lng, :duration)
  end
end
