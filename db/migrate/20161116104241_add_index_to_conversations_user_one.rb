class AddIndexToConversationsUserOne < ActiveRecord::Migration[5.0]
  def change
    add_index :conversations, [:user_one, :user_two], unique: true
  end
end
