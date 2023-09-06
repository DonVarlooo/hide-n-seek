class GamesController < ApplicationController
  def index
    if params[:lat] && params[:lng]
      lat = params[:lat].to_f
      lng = params[:lng].to_f

      @games = Game.near([lat, lng], 500).where(status: :pending).first(4)

      respond_to do |format|
        format.json {
          partial = render_to_string(partial: 'games/game_list', locals: { games: @games, user_lat: lat, user_lng: lng }, formats: :html)
          render json: { partial: partial }
        }
        format.html
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

    @current_user_game = @game.user_games.find_by(user: current_user) # Current user
    @opponent_user_game = @game.user_games.where.not(user: current_user).first # Son opposant
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

    creator_lat = @game.lat
    creator_lng = @game.lng

    opponent_lat = params[:user_lat].to_f
    opponent_lng = params[:user_lng].to_f

    center_lat, center_lng = Geocoder::Calculations.geographic_center([[creator_lat, creator_lng], [opponent_lat, opponent_lng]])

    @game.update!(lat: center_lat, lng: center_lng)

    # prepare broadcasting to creator user
    @creator_user_game = @game.user_games.first # Createur du jeu

    html = render_to_string(
      partial: "show_pending",
      locals: {
        user: @creator_user_game.user,
        game: @game,
        creator_user_game: @creator_user_game,
        challenger_user_game: @user_game,
        markers: []
      }
    )

    UserGameChannel.broadcast_to(
      @creator_user_game,
      {html: html}
    )
    # redirect for challenger user
    redirect_to game_path(@game)

  end

  def start
    @game = Game.find(params[:id])
    @game.update(status: :ongoing, started_at: Time.current)
    # redirect_to game_path(@game)
    @current_user_game = @game.user_games.find_by(user: current_user) # Current user
    @opponent_user_game = @game.user_games.where.not(user: current_user).first # Son opposant

    html1 = render_to_string(
      partial: "show_ongoing",
      locals: {
        game: @game,
        opponent_user_game: @opponent_user_game,
        markers: @markers,
        remaining_time_in_seconds: @remaining_time_in_seconds
      }
    )
    html2 = render_to_string(
      partial: "show_ongoing",
      locals: {
        game: @game,
        opponent_user_game: @current_user_game,
        markers: @markers,
        remaining_time_in_seconds: @remaining_time_in_seconds
      }
    )

      UserGameChannel.broadcast_to(
        @current_user_game,
        {html: html1}
      )

      UserGameChannel.broadcast_to(
        @opponent_user_game,
        {html: html2}
      )

    head :ok
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
            locals: {
              opponent_user_game: @opponent_user_game,
              current_user_game:  @current_user_game,
              game: @game
            },
            formats: :html
          )
          broadcast_loser
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
    @current_game = Game.find(params[:id])
    @current_user_game = @current_game.user_games.find_by(user: current_user)
    @opponent_user_game = @current_game.user_games.where.not(user: current_user).first
    # Comment on garde les photos dans les users_games
    @game = Game.new(duration: @current_game.duration,
                     name: "#{@current_game.name} - rematch",
                     lat: params[:rematch][:latitude].to_f,
                     lng: params[:rematch][:longitude].to_f,
                     mode: @current_game.mode,
                     user_id: @current_user_game.user.id)
    @game.save!
    @new_current_user_game = UserGame.create(
      user_id: @current_user_game.user.id,
      game_id: @game.id,
      win: false
    )
    # Vérifiez si la photo existe dans @current_user_game avant de l'attribuer
    @new_current_user_game.photo.attach(@current_user_game.photo.blob) if @current_user_game.photo.attached?
    @new_current_user_game.save

    @new_opponent_user_game = UserGame.create(
      user_id: @opponent_user_game.user.id,
      game_id: @game.id,
      win: false
    )
    @new_opponent_user_game.photo.attach(@opponent_user_game.photo.blob) if @opponent_user_game.photo.attached?
    @new_opponent_user_game.save
    @creator_user_game = @new_current_user_game
    @challenger_user_game = @new_opponent_user_game

    # render 'games/show', formats: [:html]
    # raise
    UserGameChannel.broadcast_to(
      @opponent_user_game,
      {url: game_path(@game)}
    )


    redirect_to game_path(@game)


  end

  private

  def game_params
    params.require(:game).permit(:lat, :lng, :duration, :name, :mode)
  end

  def broadcast_loser
    html = render_to_string(
      partial: 'games/show_finished',
      locals: {
        game: @game,
        opponent_user_game: @current_user_game,
        current_user_game:  @opponent_user_game
      },
      formats: [:html]
    )

    UserGameChannel.broadcast_to(
      @opponent_user_game,
      {html: html}
    )
  end
end
