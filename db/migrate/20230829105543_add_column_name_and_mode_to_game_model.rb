class AddColumnNameAndModeToGameModel < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :mode, :string
    add_column :games, :name, :string
  end
end
