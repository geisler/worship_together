class Church < ActiveRecord::Base
  belongs_to :user
  has_many :services, inverse_of: :church
  has_many :users

  accepts_nested_attributes_for :services
end
