# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  country    :string
#  state      :string
#  city       :string
#  street     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hotel_id   :integer
#

require 'rails_helper'

RSpec.describe Address, type: :model do
  describe "associations" do
   it { should belong_to(:hotel) }
  end

  describe "validations" do
    it { should validate_presence_of(:country) }
    it { should validate_length_of(:country).is_at_least(2).is_at_most(60) }

    it { should validate_presence_of(:state) }
    it { should validate_length_of(:state).is_at_least(2).is_at_most(40) }

    it { should validate_presence_of(:city) }
    it { should validate_length_of(:city).is_at_least(2).is_at_most(40) }

    it { should validate_presence_of(:street) }
    it { should validate_length_of(:street).is_at_least(2).is_at_most(100) }
  end

end
