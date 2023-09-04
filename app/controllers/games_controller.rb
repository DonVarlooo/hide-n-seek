class GamesController < ApplicationController
  def index

    # TODO: ME RETIRER !!!!
    # @games = [Game.last]

    # respond_to do |format|
    #   format.json {
    #     partial = render_to_string(partial: 'games/game_list', locals: { games: @games }, formats: :html)
    #     render json: { partial: partial}
    #   }
    #   format.html
    # end

    # return
    # TODO: END ME RETIRER

    if params[:lng] && params[:lat]
      @games = Game.near([params[:lat].to_f, params[:lng].to_f], 50).where(status: :pending).first(6)

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
      html
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
        html1
      )

      UserGameChannel.broadcast_to(
        @opponent_user_game,
        html2
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
        # @loser = @game.user_games.find_by(win: false).user
        # html = render_to_string(
        #   partial: 'games/show_finished',
        #   locals: {
        #     game: @game,
        #     opponent_user_game: @current_user_game,
        #     current_user_game:  @loser
        #   }
        # )

        # UserGameChannel.broadcast_to(
        #   @loser,
        #   html
        # )
        format.json do
          partial = render_to_string(
            partial: 'games/show_finished',
            locals: {
              opponent_user_game: @opponent_user_game,
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

  private

  def game_params
    params.require(:game).permit(:lat, :lng, :duration, :name, :mode)
  end
end
