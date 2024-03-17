class AddLocationToStates < ActiveRecord::Migration[7.1]
  def change
    add_column :states, :location, :integer
  end
end
