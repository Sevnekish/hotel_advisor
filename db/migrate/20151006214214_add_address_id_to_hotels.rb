class AddAddressIdToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :address_id, :integer
  end
end
