class Hotel < ActiveRecord::Base
  belongs_to :user

  mount_uploader :image, ImageUploader
  has_one :address, dependent: :destroy

  accepts_nested_attributes_for :address

  validates_associated :address

  validates :title,            presence: true
  validates :room_description, presence: true
  validates :room_price,       presence: true
end
