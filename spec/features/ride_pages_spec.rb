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
		let! (:middle) { FactoryGirl.create(:ride, date: '2014/10/19', service: service) }
		let! (:last) { FactoryGirl.create(:ride, date: '2014/10/26', service: service) }
		let! (:first) { FactoryGirl.create(:ride, date: '2014/10/12', service: service) }

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
    end
end
