class Address < ActiveRecord::Base
  belongs_to :hotel

  validates_presence_of :country, :state, :city, :street 
end
