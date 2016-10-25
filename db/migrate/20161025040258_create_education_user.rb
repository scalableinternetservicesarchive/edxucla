class CreateEducationUser < ActiveRecord::Migration[5.0]
  def change
    create_table :education_users do |t|
      t.integer :user_id
      t.integer :education_id
    end

    add_foreign_key :education_users, :users
    add_foreign_key :education_users, :educations
  end
end
