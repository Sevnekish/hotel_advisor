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

class Hotel < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader
  has_one :address, dependent: :destroy
  has_many :reviews

  accepts_nested_attributes_for :address

  validates_associated :address

  validates :title,            presence: true
  validates :room_description, presence: true
  validates :room_price,       presence: true
end