class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home
  end

  def index
  end

  def thanks
  end
end
