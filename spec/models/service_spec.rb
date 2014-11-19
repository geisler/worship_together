require 'spec_helper'

describe Service do
    let(:service) { FactoryGirl.create(:service) }
    subject { service }

    it { should respond_to(:day_of_week) }
    it { should respond_to(:start_time) }
    it { should respond_to(:finish_time) }
    it { should respond_to(:location) }

    it { should respond_to(:church) }
    it { should respond_to(:rides) }

    describe "required Church relationship" do
	before { service.church_id = nil }

	it { should_not be_valid }
    end

    describe "empty start time" do
	before { service.start_time = nil }

	it { should_not be_valid }
    end

    describe "blank start time" do
	before { service.start_time = ' ' }

	it { should_not be_valid }
    end

    describe "empty finish time" do
	before { service.finish_time = nil }

	it { should_not be_valid }
    end

    describe "blank start time" do
	before { service.finish_time = ' ' }

	it { should_not be_valid }
    end

    describe "empty day of week" do
	before { service.day_of_week = nil }

	it { should_not be_valid }
    end

    describe "blank day of week" do
	before { service.day_of_week = ' ' }

	it { should_not be_valid }
    end

    describe "empty location" do
	before { service.location = nil }

	it { should_not be_valid }
    end

    describe "blank location" do
	before { service.location = ' ' }

	it { should_not be_valid }
    end
end
