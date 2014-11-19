class Service < ActiveRecord::Base
  belongs_to :church, inverse_of: :services
  has_many :rides

  validates :church, presence: true
end
