class RemoveCoordinatesToGames < ActiveRecord::Migration[7.0]
  def change
    remove_column :games, :latitude, :float
    remove_column :games, :longitude, :float
  end
end
