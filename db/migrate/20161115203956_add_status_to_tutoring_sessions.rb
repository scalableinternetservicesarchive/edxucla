class AddStatusToTutoringSessions < ActiveRecord::Migration[5.0]
  def change
    add_column :tutoring_sessions, :status, :string
  end
end
