class UserMessageController < ApplicationController
  def messages
    user = current_user

  end

  def new_message
    if params[:user].nil?
      return
    end

    @user = User.find(params[:user])
  end

  def send_new_message

    unless params[:message].empty?
      curr_user_id = current_user.id

      #create conversation or find it if it already exists
      conversation_params = {}
      conversation_params[:user_one] = curr_user_id
      conversation_params[:user_two] = params[:user]

      #prevent race conditions
      conversation = Conversation.safe_find_or_create_by(conversation_params)

      message_params = {}
      message_params[:message] = params[:message]
      message_params[:sender] = curr_user_id
      message_params[:receiver] = params[:user]
      message_params[:conversation_id] = conversation.id

      user_message = UserMessage.create(message_params)

      flash[:success] = "Message Sent"
      redirect_to User.find(params[:user])
    else
      flash[:success] = "Message Sent"
      redirect_to User.find(params[:user])
    end
  end
end
