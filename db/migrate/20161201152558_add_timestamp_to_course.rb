class AddTimestampToCourse < ActiveRecord::Migration[5.0]
  def change
    add_column(:courses, :created_at, :datetime)
    add_column(:courses, :updated_at, :datetime)
  end
end
