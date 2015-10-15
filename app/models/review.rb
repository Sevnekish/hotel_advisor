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

  private
    def recalculate_hotel_rating
      self.hotel.recalculate_rating
    end
end