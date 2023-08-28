class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.float :lat
      t.float :lng
      t.float :radius
      t.integer :duration

      t.timestamps
    end
  end
end
