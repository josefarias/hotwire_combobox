class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.references :favorite_state, foreign_key: { to_table: :states }
      t.references :home_state, foreign_key: { to_table: :states }

      t.timestamps
    end
  end
end
