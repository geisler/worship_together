require 'spec_helper'

describe 'Service Pages' do
    subject { page }

    describe "show services" do
	describe "all" do
	    let (:church) { FactoryGirl.create(:church, num_services: 25) }

	    before { visit church_services_path(church) }

	    it { should have_content('List of services') }
	    it { should have_content('25 services') }

	    it "should show all services" do
		Service.all.each do |service|
		    should have_selector('li', text: service.church.name)
		    should have_selector('li', text: service.day_of_week)
		    should have_selector('li', text: service.start_time)
		end
	    end

	    describe "by day of week" do
		let! (:wed) { FactoryGirl.create(:service, church: church, day_of_week: 'Wednesday') }
		let! (:sat) { FactoryGirl.create(:service, church: church, day_of_week: 'Saturday') }
		let! (:sun) { FactoryGirl.create(:service, church: church, day_of_week: 'Sunday') }

		before { visit church_services_path(church, order: :Day) }

		it { should have_content(/#{sun.day_of_week}.*#{wed.day_of_week}.*#{sat.day_of_week}/) }
	    end

	    describe "by time of day" do
		let! (:normal) { FactoryGirl.create(:service, church: church, start_time: '9:00 AM') }
		let! (:early) { FactoryGirl.create(:service, church: church, start_time: '6:00 AM') }
		let! (:late) { FactoryGirl.create(:service, church: church, start_time: '6:00 PM') }

		before { visit church_services_path(church, order: :Time) }

		it { should have_content(/#{early.start_time}.*#{normal.start_time}.*#{late.start_time}/) }
	    end
	end

	describe "individual" do
	    let (:service) { FactoryGirl.create(:service, num_rides: 25) }

	    before { visit service_path(service) }

	    it { should have_content(service.day_of_week) }
	    it { should have_content(service.start_time) }
	    it { should have_content(service.finish_time) }
	    it { should have_content(service.location) }

	    it "should show all associated rides" do
		service.rides.each do |ride|
		    within("div.ride#{ride.id}") do
			have_content(ride.date)
			have_content(ride.seats_available)
			have_content(ride.meeting_location)
		    end
		end
	    end
	end
    end
end
