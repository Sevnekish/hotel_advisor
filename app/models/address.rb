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

  validates :country, presence: true, length: { in: 2..60 }
  validates :state,   presence: true, length: { in: 2..40 }
  validates :city,    presence: true, length: { in: 2..40 }
  validates :street,  presence: true, length: { in: 2..100 }

end
