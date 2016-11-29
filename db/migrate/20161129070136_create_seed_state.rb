class CreateSeedState < ActiveRecord::Migration[5.0]
  def change
    create_table :seed_states do |t|
      t.boolean :status, null: false
      t.index :status, unique: true

      t.timestamps null: false
    end
  end
end
