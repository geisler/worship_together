require 'spec_helper'

describe 'Service Pages' do
    subject { page }

    describe "show services" do
	describe "all" do
	    let (:num_services) { Kernel.rand(20..30) }
	    let (:church) { FactoryGirl.create(:church, num_services: num_services) }

	    before { visit church_services_path(church) }

	    it { should have_content('List of services') }
	    it { should have_content("#{num_services} services") }

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
	    let (:num_rides) { Kernel.rand(20..30) }
	    let (:service) { FactoryGirl.create(:service, num_rides: num_rides) }

	    before { visit service_path(service) }

	    it { should have_content(service.day_of_week) }
	    it { should have_content(service.start_time) }
	    it { should have_content(service.finish_time) }
	    it { should have_content(service.location) }

	    it "should show all associated rides" do
		service.rides.each do |ride|
		    within("div.ride#{ride.id}") do
			should have_content(ride.date)
			should have_content(ride.seats_available)
			should have_content(ride.meeting_location)
			should have_link('more info', href: ride_path(ride))
		    end
		end
	    end


	    describe "marks the ride provider properly" do
		let (:ride) { service.rides.first }
		let (:user) { ride.user }

		before do
		    user.password = "password" # hack
		    login user
		    visit service_path(service)
		end

		it { should have_selector("div.ride#{ride.id}",
					  text: '(provider)') }
	    end

	    describe "marks the rider properly" do
		let (:ride) { service.rides.first }
		let (:user) { ride.users.first }

		before do
		    user.password = "password" # hack
		    login user
		    visit service_path(service)
		end

		it { should have_selector("div.ride#{ride.id}",
					  text: '(rider)') }
	    end

	    describe "allow the user to provide a ride" do
		let (:user) { FactoryGirl.create(:user) }
		let (:submit) { 'Offer ride' }

		before do
		    login user
		    visit service_path(service)
		end

		it { should have_field('Date') }
		it { should have_field('Leave time') }
		it { should have_field('Return time') }
		it { should have_field('Number of seats') }
		it { should have_field('Seats available') }
		it { should have_field('Meeting location') }
		it { should have_field('Vehicle') }
		it { should have_button(submit) }

		describe "with invalid information" do
		    it "does not add the ride to the system" do
			expect { click_button submit }.not_to change(Ride, :count)
		    end

		    it "produces an error message" do
			click_button submit
			should have_alert(:danger)
		    end
		end

		describe "with valid information" do
		    before do
			fill_in 'Date', with: (Date.today + 1.day).to_s
			fill_in 'Leave time', with: '8:30 AM'
			fill_in 'Return time', with: '11:30 AM'
			fill_in 'Number of seats', with: '5'
			fill_in 'Seats available', with: '3'
			fill_in 'Meeting location', with: 'DC'
			fill_in 'Vehicle', with: '4-door sedan'
		    end

		    it "allows the user to fill in the fields" do
			click_button submit
		    end

		    it "does add the ride to the system" do
			expect { click_button submit }.to change(Ride, :count).by(1)
		    end

		    describe "produces a success message" do
			before { click_button submit }

			it { should have_alert(:success) }
		    end

		    describe "redirects to ride page", type: :request do
			before do
			    login user, avoid_capybara: true
			    post service_rides_path(service),
				ride: { date: (Date.today + 1.day).to_s,
					leave_time: '8:30 AM',
					return_time: '11:30 AM',
					number_of_seats: '5',
					seats_available: '3',
					meeting_location: 'DC',
					vehicle: '4-door sedan' }
			end

			specify do
			    expect(response).to redirect_to(ride_path(assigns(:ride)))
			end
		    end
		end
	    end
	end
    end
end
