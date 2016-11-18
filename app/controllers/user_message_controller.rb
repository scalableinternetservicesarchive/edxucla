class UserMessageController < ApplicationController
  skip_before_action :verify_authenticity_token
  def messages
    @conversation_error = false;
    
    @user = current_user
    if @current_user.nil?
      @conversation_error = true;
      return
    end

    @conversations = Conversation.where('user_one = :sender OR user_two = :receiver' , sender: @user.id, receiver: @user.id)
    i = 0
    messages = []
    users = []

    while i < @conversations.count
      messages[i] = UserMessage.where(conversation_id: @conversations[i].id)
      if @conversations[i][:user_one] == @user.id
        users[i] = User.find(@conversations[i][:user_two])
      elsif @conversations[i][:user_two] == @user.id
        users[i] = User.find(@conversations[i][:user_one])
      end
      i += 1
    end

    @messages = messages
    @users = users
    @active_conversation = 0
  end

  def show
    #error if user isnt one of the users in this conversation

    @user = current_user
    conversation_id = params[:id]
    active_conversation = Conversation.find_by(id: params[:id])
    @conversation_error = false;
    
    @active_conversation = 0

    if conversation_id.nil?
      @conversation_error = true
      render 'messages'
      return
    end

    if active_conversation.nil?
      @conversation_error = true
      render 'messages'
      return
    end

    if @user.id != active_conversation[:user_one] && @user.id != active_conversation[:user_two]
      @conversation_error = true
      render 'messages'
      return
    end

    @conversations = Conversation.where('user_one = :sender OR user_two = :receiver' , sender: @user.id, receiver: @user.id)
    i = 0
    messages = []
    users = []

    while i < @conversations.count
      messages[i] = UserMessage.where(conversation_id: @conversations[i].id)
      if @conversations[i][:user_one] == @user.id
        users[i] = User.find(@conversations[i][:user_two])
      elsif @conversations[i][:user_two] == @user.id
        users[i] = User.find(@conversations[i][:user_one])
      end

      if @conversations[i][:id] == active_conversation[:id]
        @active_conversation = i
      end
      i += 1
    end

    @messages = messages
    @users = users
    render 'messages'

  end




  def new_message
    if params[:user].nil?
      return
    end

    @user = User.find(params[:user])
  end

  def send_message
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
    else
      #empty message
    end
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
      #TODO: handle empty message
      flash[:success] = "Empty Message Sent"
      redirect_to User.find(params[:user])
    end
  end
end
