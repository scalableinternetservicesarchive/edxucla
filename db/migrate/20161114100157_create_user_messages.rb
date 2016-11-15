class CreateUserMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :user_messages do |t|
      t.string :message
      t.integer :sender
      t.integer :receiver

      t.timestamps
    end
  end
end
