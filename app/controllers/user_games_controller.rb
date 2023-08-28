class UserGamesController < ApplicationController
  def create
    @game = Game.find
  end
end
