class AddConversationIdToUserMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :user_messages, :conversation_id, :integer
  end
end
