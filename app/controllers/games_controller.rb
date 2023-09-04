class GamesController < ApplicationController
  def index
    if params[:lng] && params[:lat]
      @games = Game.near([params[:lat].to_f, params[:lng].to_f], 500).where(status: :pending).first(4)
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

    if @game.ongoing?
      expected_end_time = @game.started_at + @game.duration.minutes
      @remaining_time_in_seconds = expected_end_time - Time.current
    end

    @creator_user_game = @game.user_games.first # Createur du jeu
    @challenger_user_game = @game.user_games.second # Joueur qui rejoint le jeu

    @current_user_game = @game.user_games.find_by(user: current_user) # Createur du jeu
    @opponent_user_game = @game.user_games.where.not(user: current_user).first # Createur du jeu

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

    @user_game = UserGame.new(photo: params.require(:game).require(:photo))
    @user_game.game = @game
    @user_game.user = current_user
    @user_game.save!

    redirect_to game_path(@game)
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy
  end

  def join
    @game = Game.find(params[:id])
    @user_game = UserGame.new
    @user_game.game = @game
    @user_game.user = current_user
    @user_game.save!

    redirect_to game_path(@game)
  end

  def start
    @game = Game.find(params[:id])
    @game.update(status: :ongoing, started_at: Time.current)
    redirect_to game_path(@game)
  end

  def scan
    @game = Game.find(params[:id])
    @current_user_game = @game.user_games.find_by(user: current_user)
    @opponent_user_game = @game.user_games.where.not(user: current_user).first
    @opponent = @opponent_user_game.user

    respond_to do |format|
      if @opponent.id == params[:opponent_id].to_i
        @current_user_game.update(win: true)
        @game.update(status: :finished, ended_at: Time.current)

        format.json do
          partial = render_to_string(
            partial: 'games/show_finished',
            locals: {opponent_user_game: @opponent_user_game,
                     current_user_game:  @current_user_game
            },
            formats: :html
          )
          render json: {
            success: true,
            partial:
          }
        end
      else
        format.json do
          render json: {
            success: false
          }
        end
      end
    end
  end

  def rematch
    @game = Game.find(params[:id])
    @usergames = @game.user_games
    # Comment on garde les photos dans les users_games
    @new_game = Game.new(duration: @game.duration,
                         name: "#{@game.name} - rematch",
                         lat: @game.lat,
                         lng: @game.lng,
                         mode: @game.mode)
    @new_game.save!
    @current_user.update(game: @new_game)
    @opponent_user.update(game: @new_game)
    # raise
    redirect_to game_path(@new_game)

    # 1 button link to qui redirige vers la fonction rematch
    # 2 Creer des nouveaux usergame (pour préserver l'histo) tout en gardant les photos !
    # 3 faire un raise
    # 4 Dans l'url mettre une postion fake (lat et lng) et s'assurer que le rematch fonctionne
    # 5 Créer un nouveau controller stimumus "Rematch Controller" avec un data-action qui écoute le click sur le boutton stimumlus
    # 6 Au click recuperer les données de la position du user.
    # 7 Fetcher l'url vers l'action rematch du controller game (au link_to)
  end

  private

  def game_params
    params.require(:game).permit(:lat, :lng, :duration, :name, :mode)
  end
end
