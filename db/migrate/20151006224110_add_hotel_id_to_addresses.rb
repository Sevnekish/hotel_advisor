class AddHotelIdToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :hotel_id, :integer
  end
end
