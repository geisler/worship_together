require 'spec_helper'

describe 'Ride Pages' do
    subject { page }

    describe "show rides" do
	describe "all" do
	    let (:service) { FactoryGirl.create(:service, num_rides: 25) }

	    before { visit service_rides_path(service) }

	    it { should have_content('List of rides') }
	    it { should have_content("25 rides") }

	    it "should show all rides" do
		service.rides.each do |ride|
		    should have_selector('li', text: ride.user.name)
		    should have_selector('li', text: ride.service.church.name)
		    should have_selector('li', text: ride.date)
		end
	    end

	    describe "by date" do
		let! (:middle) { FactoryGirl.create(:ride, date: '2016/10/19', service: service) }
		let! (:last) { FactoryGirl.create(:ride, date: '2016/10/26', service: service) }
		let! (:first) { FactoryGirl.create(:ride, date: '2016/10/12', service: service) }

		before { visit service_rides_path(service, order: :Date) }

		it { should have_content(/#{first.date}.*#{middle.date}.*#{last.date}/) }
	    end

#
# Currently, this doesn't make sense since a ride is nested for a
# particular service.  We could look into a different interface should
# this type of output be necessary
#
#	    describe "by service" do
#		let! (:service1) { FactoryGirl.create(:service) }
#		let! (:service2) { FactoryGirl.create(:service) }
#		let! (:middle) { FactoryGirl.create(:ride,
#						    date: '2014/10/19',
#						    service: service2) }
#		let! (:last) { FactoryGirl.create(:ride,
#						  date: '2014/10/26',
#						  service: service1) }
#		let! (:first) { FactoryGirl.create(:ride,
#						   date: '2014/10/12',
#						   service: service1) }
#
#		before { visit rides_path(order: :Service) }
#
#		it { should have_content(/#{last.date}.*#{first.date}.*#{middle.date}/) }
#	    end
	end

	describe "individually" do
	    let (:ride) { FactoryGirl.create(:ride) }
	    let (:claim) { 'Claim ride' }

	    before { visit ride_path(ride) }

	    it { should have_content(ride.service.church.name) }
	    it { should have_content(ride.service.location) }
	    it { should have_link(ride.user.name, href: user_path(ride.user)) }
	    it { should have_content(ride.leave_time) }
	    it { should have_content(ride.return_time) }
	    it { should have_content(ride.meeting_location) }
	    it { should have_content(ride.vehicle) }
	    it { should have_content(ride.seats_available) }
	    it { should have_content(ride.number_of_seats) }

	    it { should_not have_button(claim) }

	    describe "claiming a ride" do
		let (:user) { FactoryGirl.create(:user) }
		let!(:orig_seats) { ride.seats_available }

		before do
		    login user
		    visit ride_path(ride)
		end

		it { should have_button(claim) }

		it "changes the data" do
		    click_button claim
		    expect(ride.reload.seats_available).to eq(orig_seats - 1)
		end

		it "creates a user ride" do
		    expect { click_button claim }.to change(UserRide, :count).by(1)
		end

		it "produces an update message" do
		    click_button claim
		    should have_alert(:success)
		end
	    end
	end
    end
end
