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

class Address < ActiveRecord::Base
  belongs_to :hotel

  validates_presence_of :country, :state, :city, :street 
end
