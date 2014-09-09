class Service < ActiveRecord::Base
  belongs_to :church
  has_many :rides
end
