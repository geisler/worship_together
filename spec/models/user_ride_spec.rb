require 'spec_helper'

describe UserRide do
    let(:user_ride) { FactoryGirl.create(:user_ride) }
    subject { user_ride }

    it { should respond_to(:ride) }
    it { should respond_to(:user) }

    describe "required Ride relationship" do
	before { user_ride.ride_id = nil }

	it { should_not be_valid }
    end

    describe "required User relationship" do
	before { user_ride.user_id = nil }

	it { should_not be_valid }
    end
end
