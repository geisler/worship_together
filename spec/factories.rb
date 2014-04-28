FactoryGirl.define do
    factory :user do
	sequence(:name) { |i| "User #{i}" }
	sequence(:email) { |i| "user.#{i}@example.com" }
	password 'password'
	password_confirmation 'password'
    end
end
