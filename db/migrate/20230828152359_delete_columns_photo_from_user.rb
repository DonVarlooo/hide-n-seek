class DeleteColumnsPhotoFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :avatar
  end
end
