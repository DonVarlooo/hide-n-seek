class MessagesController < ApplicationController
  def create
    @game = Game.find(params[:game_id])
    @message = Message.new(message_params)
    @message.game = @game
    @message.user = current_user
    @message.save!
  end


  private

  def message_params
    params.require(:message).permit(:content)
  end
end
