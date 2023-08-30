class RemoveLongitudeFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :longitude, :float
  end
end
