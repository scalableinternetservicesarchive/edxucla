class AddTimestampToTutoringSession < ActiveRecord::Migration[5.0]
  def change
    add_column(:tutoring_sessions, :created_at, :datetime)
    add_column(:tutoring_sessions, :updated_at, :datetime)
  end
end
