class AddQrCodesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :qr_code, :string
  end
end
