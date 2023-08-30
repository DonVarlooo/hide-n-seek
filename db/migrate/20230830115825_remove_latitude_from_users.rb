class RemoveLatitudeFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :latitude, :float
  end
end
