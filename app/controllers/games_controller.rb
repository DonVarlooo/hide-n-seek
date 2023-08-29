class GamesController < ApplicationController
  def index
    if params[:lng] && params[:lat]
      @games = Game.near([params[:lat].to_f, params[:lng].to_f], 1)
      respond_to do |format|
        format.json {
          partial = render_to_string(partial: 'games/game_list', locals: { games: @games }, formats: :html)
          render json: { partial: partial}
        }
      end
    else
      @games = Game.all
    end
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

# 1 quand j'arrive sur la page d'index des games, j'affiche un loader à l'emplacemen des games
# 2 je crée un controller stimulus qui va
  # 1 au connect demander la geoloc de lutilisateur navigator.GetCurrentPos caca
  # 2 une fois que la position a été recupérée, je vais fetch le games index, en passant dans l'url, des params (lat lng)
  #  et dans laction index du games controller, je respond_to format.json/text pour charger la partial de la liste des games
  #  et pouet pouet
