class User < ActiveRecord::Base
    has_many :rides_provided, class_name: 'Ride', foreign_key: 'user_id'
    has_many :user_rides
    has_many :rides, through: :user_rides

    has_one :church
# if the church profile manager doesn't attend that church, use:
#    has_one :church_managed, class_name: 'Church', foreign_key: 'user_id'

    has_secure_password

    validates :name, presence: true
    validates :email, presence: true
    validates :password, presence: true
end
