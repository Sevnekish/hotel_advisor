class CreateHotels < ActiveRecord::Migration
  def change
    create_table :hotels do |t|
      t.string  :title
      t.boolean :breakfast_included
      t.string  :room_description
      t.decimal :room_price

      t.timestamps null: false
    end
  end
end
