class Service < ActiveRecord::Base
  belongs_to :church
  has_many :rides

  validates :church, presence: true
end
