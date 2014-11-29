require 'spec_helper'

describe Ride do
    let(:ride) { FactoryGirl.create(:ride) }
    subject { ride }

    it { should respond_to(:date) }
    it { should respond_to(:leave_time) }
    it { should respond_to(:return_time) }
    it { should respond_to(:number_of_seats) }
    it { should respond_to(:seats_available) }
    it { should respond_to(:meeting_location) }
    it { should respond_to(:vehicle) }

    it { should respond_to(:service) }
    it { should respond_to(:user_rides) }
    it { should respond_to(:user) }
    it { should respond_to(:users) }

    describe "required Service relationship" do
	before { ride.service_id = nil }

	it { should_not be_valid }
    end

    describe "required User relationship" do
	before { ride.user_id = nil }

	it { should_not be_valid }
    end

    describe "empty date" do
	before { ride.date = '' }

	it { should_not be_valid }
    end

    describe "blank date" do
	before { ride.date = ' ' }

	it { should_not be_valid }
    end

    describe "empty leave time" do
	before { ride.leave_time = '' }

	it { should_not be_valid }
    end

    describe "blank leave time" do
	before { ride.leave_time = ' ' }

	it { should_not be_valid }
    end

    describe "empty return time" do
	before { ride.return_time = '' }

	it { should_not be_valid }
    end

    describe "blank return time" do
	before { ride.return_time = ' ' }

	it { should_not be_valid }
    end

    describe "empty number of seats" do
	before { ride.number_of_seats = '' }

	it { should_not be_valid }
    end

    describe "blank number of seats" do
	before { ride.number_of_seats = ' ' }

	it { should_not be_valid }
    end

    describe "empty seats available" do
	before { ride.seats_available = '' }

	it { should_not be_valid }
    end

    describe "blank seats available" do
	before { ride.seats_available = ' ' }

	it { should_not be_valid }
    end

    describe "empty meeting location" do
	before { ride.meeting_location = '' }

	it { should_not be_valid }
    end

    describe "blank meeting location" do
	before { ride.meeting_location = ' ' }

	it { should_not be_valid }
    end

    describe "empty vehicle" do
	before { ride.vehicle = '' }

	it { should_not be_valid }
    end

    describe "blank vehicle" do
	before { ride.vehicle = ' ' }

	it { should_not be_valid }
    end
end
