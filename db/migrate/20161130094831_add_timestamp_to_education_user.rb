class AddTimestampToEducationUser < ActiveRecord::Migration[5.0]
  def change
    add_column(:education_users, :created_at, :datetime)
    add_column(:education_users, :updated_at, :datetime)
  end
end
