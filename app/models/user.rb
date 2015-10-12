class User < ActiveRecord::Base
  has_many :hotels
	
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
