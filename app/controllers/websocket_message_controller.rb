class WebsocketMessageController < ApplicationController
  def recieve_message
    message=message();
    broadcast_message :show_message,message
  end
end
