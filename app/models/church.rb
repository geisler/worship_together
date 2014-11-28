class Church < ActiveRecord::Base
  belongs_to :user, inverse_of: :church_managed
  has_many :services, inverse_of: :church
  has_many :users, inverse_of: :church

  accepts_nested_attributes_for :services
end
