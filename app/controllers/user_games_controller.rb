class UserGamesController < ApplicationController
  def update
    @usergame = current_user.user_games.find(params[:id])
    @usergame.update(user_game_params)
    redirect_to game_path(@usergame.game)
  end

  private

  def user_game_params
    params.require(:user_game).permit(:photo)
  end
end
