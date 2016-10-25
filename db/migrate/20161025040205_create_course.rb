class CreateCourse < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.integer :education_id
      t.string :department
      t.string :name
      t.string :alias
    end

    add_foreign_key :courses, :educations
  end
end
