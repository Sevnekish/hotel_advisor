class AddRatingToHotels < ActiveRecord::Migration
  def change
    add_column :hotels, :rating, :decimal
  end
end
