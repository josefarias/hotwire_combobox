class CreateStates < ActiveRecord::Migration[7.0]
  def change
    create_table :states do |t|
      t.string :abbreviation
      t.string :name, null: false

      t.timestamps
    end
  end
end
