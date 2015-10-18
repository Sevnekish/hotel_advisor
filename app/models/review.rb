# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  body       :text
#  rating     :integer
#  hotel_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Review < ActiveRecord::Base
  belongs_to :hotel
  belongs_to :user

  after_create :recalculate_hotel_rating
  after_update :recalculate_hotel_rating
  after_destroy :recalculate_hotel_rating

  default_scope -> { order(created_at: :desc) }

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :body,   presence: true, length: { in: 4..200 }
  validates :hotel,  presence: true
  validates :user,  presence: true
  validates_uniqueness_of :hotel_id, scope: :user_id

  private
    def recalculate_hotel_rating
      self.hotel.recalculate_rating
    end
end