class PagesController < ApplicationController
  def home
  end

  def show
    @friend = Friend.find(params[:id])
  end
end
