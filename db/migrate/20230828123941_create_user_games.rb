class CreateUserGames < ActiveRecord::Migration[7.0]
  def change
    create_table :user_games do |t|
      t.boolean :win
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
