class UserMessageController < ApplicationController
  #skip_before_action :verify_authenticity_token
  def messages
    @conversation_error = false;
    @conversation_error_message = "You do not have access to this conversation"

    @user = current_user
    if @current_user.nil?
      @conversation_error = true;
      return
    end

    @conversations = Conversation.where('user_one = :sender OR user_two = :receiver' , sender: @user.id, receiver: @user.id)
    i = 0

    if @conversations.empty?
      @conversation_error = true;
      @conversation_error_message = "You have no messages."
      return
    end

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

    fresh_when(@messages)

  end

  def fetch_messages
    # data needed: check if new conversations
    # if so, add that data into the left column, only need to fetch
    # user gravatar, user name/id, and most recent message
    # check if any new user_messages
    # if there are new messages in this conversation
    # append
    # if there are new messages in other conversations, show user
    # something to let them know there are unread messages in another
    # conversation

    #currently queries only current conversation messages

    other_user_id = params[:other_user_id]
    last_message_time = Time.at(params[:last_message_time].to_i).utc
    last_message_id = params[:last_message_id]

    user = current_user

    messages = UserMessage.where('updated_at > :time and sender = :sender and receiver = :receiver', time: last_message_time, sender: other_user_id, receiver: user.id)

    # conversations = Conversation.where('updated_at > :time and user_one = :sender or user_two = :receiver' , time: time, sender: user.id, receiver: user.id)

    response = []

    messages.each do |message|
      if message.id != last_message_id.to_i
        response.push({
          id: message.id,
          message: message.message,
          sender: message.sender,
          receiver: message.receiver,
          created_at_time: message.created_at.to_i,
          created_at: message.created_at.in_time_zone("Pacific Time (US & Canada)").strftime("%m/%d/%Y %I:%M%p"),
          updated_at: message.updated_at.in_time_zone("Pacific Time (US & Canada)").strftime("%m/%d/%Y %I:%M%p"),
          conversation_id: message.conversation_id
          })
      end
    end

    # conversations.each do |conversation|
    #   response.push({
    #     id: conversation.id,
    #     user_one: conversation.user_one,
    #     user_two: conversation.user_two,
    #     created_at: conversation.created_at,
    #     updated_at: conversation.updated_at
    #     })
    # end

    # puts @conversations.inspect
    render json: response
  end

  def fetch_messages_header
    user = current_user
    if user.nil?
      return
    end

    time = Time.now - 5.seconds

    messages = UserMessage.where('updated_at > :time and receiver = :receiver', time: time, receiver: user.id)

    response = messages.count

    render json: response
  end


  def show
    #error if user isnt one of the users in this conversation

    @user = current_user
    conversation_id = params[:id]
    active_conversation = Conversation.find_by(id: params[:id])
    @conversation_error = false;
    @conversation_error_message = "You do not have access to this conversation"
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
    render 'messages' if stale?(@messages)
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
      #conversation = Conversation.safe_find_or_create_by(conversation_params)

      conversation = Conversation.safe_where_or_create_by(conversation_params)

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
      #conversation = Conversation.safe_find_or_create_by(conversation_params)

      conversation = Conversation.safe_where_or_create_by(conversation_params)

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
