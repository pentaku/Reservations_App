class AddAddressToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :address, :string
  end
end
