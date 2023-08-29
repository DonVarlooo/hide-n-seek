class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find(params[:id])
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    @game.save
  end

  private

  def game_params
    params.require(:game).permit(:lat, :lng, :duration, :radius)
  end
end
