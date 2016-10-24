class CreateEducations < ActiveRecord::Migration[5.0]
  def change
    create_table :educations do |t|
      t.string :name
      t.string :alias
      t.string :course_id
      t.string :course_name
      
      t.timestamps
    end
  end
end
