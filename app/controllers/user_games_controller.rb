class UserGamesController < ApplicationController
  def update
    @user_game = current_user.user_games.find(params[:id])
    @user_game.update(user_game_params)

    @game = @user_game.game
    @creator_user_game = @game.user_games.first # Createur du jeu
    @challenger_user_game = @game.user_games.second # Joueur qui rejoint le jeu

    # redirect_to game_path(@user_game.game)

    # TODO: broadcast pour les deux !!
    # ATTENTION, on va pas render avec les memes arguments

    html_creator = render_to_string(
      partial: "games/show_pending",
      locals: {
        user: @creator_user_game.user,
        game: @game,
        creator_user_game: @creator_user_game,
        challenger_user_game: @user_game,
        markers: []
      }
    )

    html_opponent = render_to_string(
      partial: "games/show_pending",
      locals: {
        user: @user_game.user,
        game: @game,
        creator_user_game: @creator_user_game,
        challenger_user_game: @user_game,
        markers: []
      }
    )

    UserGameChannel.broadcast_to(
      @creator_user_game,
      {html: html_creator}
    )

    UserGameChannel.broadcast_to(
      @user_game,
      {html: html_opponent}
    )

    head :ok
    # redirect_to game_path(@user_game.game)


  end

  private

  def user_game_params
    params.require(:user_game).permit(:photo)
  end
end
