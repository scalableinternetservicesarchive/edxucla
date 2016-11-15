class CreateUserRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :user_requests do |t|
      t.string :request_type
      t.integer :sender
      t.integer :receiver
      t.integer :course_id
      
      t.timestamps
    end
  end
end
