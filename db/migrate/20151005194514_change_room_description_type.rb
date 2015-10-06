class ChangeRoomDescriptionType < ActiveRecord::Migration
  def change
    change_table :hotels do |t|
      t.change :room_description, :text
    end
  end
end
