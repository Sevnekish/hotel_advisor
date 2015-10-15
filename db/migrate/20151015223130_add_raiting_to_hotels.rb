class AddRaitingToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :rating, :decimal, :default => 0
  end
end
