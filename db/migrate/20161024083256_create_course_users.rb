class CreateCourseUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :course_users do |t|
      t.string :user_id
      t.string :school
      t.string :course_id
      t.string :course_name
      
      t.timestamps
    end
  end
end
