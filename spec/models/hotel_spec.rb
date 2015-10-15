# == Schema Information
#
# Table name: hotels
#
#  id                 :integer          not null, primary key
#  title              :string
#  breakfast_included :boolean
#  room_description   :text
#  room_price         :decimal(, )
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  rating             :decimal(, )
#  image              :string
#

require 'rails_helper'

RSpec.describe Hotel, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
