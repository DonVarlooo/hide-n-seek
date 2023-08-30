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
    @game = Game.new
  end

  def show
    @game = Game.find(params[:id])
    @user_game = UserGame.new
    @user_game.game_id = @game

    # dans la vue:
    # si le current user = @game.user, render la vue owner avec status pending
    # sinon afficher la vue user qui join, dans cette vue, on voit l'adversaire
    # et on doit prendre un selfie avant de valider.

    # Quand la photo est upload, le status de la partie change et l'owner peut
    # lancer le début de la partie

    # dans le controller:
    # il faut créer une instance de @game_users
    # le game owner est un de ses users et celui qui rejoint également
    # il faudra stocker leur selfie dans le @game_users et la récupérer dans la db
  end

  def create
    @game = Game.new(game_params)
    @game.user = current_user
    @game.save!

    @user_game = UserGame.new
    @user_game.game = @game
    @user_game.user = current_user
    @user_game.save!

    redirect_to game_path(@game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
  end

  private

  def game_params
    params.require(:game).permit(:lat, :lng, :duration, :name, :mode)
  end
end
