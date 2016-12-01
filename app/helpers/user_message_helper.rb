module UserMessageHelper
  def cache_for_user_message(user_message)
    "user_message-#{user_message.id}-#{user_message.updated_at}"
  end
end
