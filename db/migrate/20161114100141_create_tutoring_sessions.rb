class CreateTutoringSessions < ActiveRecord::Migration[5.0]
  def change
    create_table :tutoring_sessions do |t|
      t.integer :tutor
      t.integer :student
      t.integer :course_id
    end
  end
end
