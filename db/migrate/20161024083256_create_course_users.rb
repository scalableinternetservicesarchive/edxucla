class CreateCourseUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :course_users do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :education_id
      t.string :education_alias
      t.string :course_alias
      t.string :course_name

      t.timestamps
    end

    add_foreign_key :course_users, :users
    add_foreign_key :course_users, :users
    add_foreign_key :course_users, :users
  end
end
