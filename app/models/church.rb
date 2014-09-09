class Church < ActiveRecord::Base
  belongs_to :user
  has_many :services
  has_many :users
end
