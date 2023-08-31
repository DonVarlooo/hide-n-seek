class AddStatusToGames < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :status, :integer, default: 0, null: false, index: true
  end
end
