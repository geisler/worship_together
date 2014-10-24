require 'spec_helper'

describe 'Ride Pages' do
    subject { page }

    describe "show rides" do
	describe "all" do
	    before do
		25.times { FactoryGirl.create(:ride) }
		visit rides_path
	    end

	    it { should have_content('List of rides') }
	    it { should have_content('25 rides') }

	    it "should show all rides" do
		Ride.all.each do |ride|
		    should have_selector('li', text: ride.user.name)
		    should have_selector('li', text: ride.service.church.name)
		    should have_selector('li', text: ride.date)
		end
	    end

	    describe "by date" do
		let! (:middle) { FactoryGirl.create(:ride, date: '2014/10/19') }
		let! (:last) { FactoryGirl.create(:ride, date: '2014/10/26') }
		let! (:first) { FactoryGirl.create(:ride, date: '2014/10/12') }

		before { visit rides_path(order: :Date) }

		it { should have_content(/#{first.date}.*#{middle.date}.*#{last.date}/) }
	    end

	    describe "by service" do
		let! (:service1) { FactoryGirl.create(:service) }
		let! (:service2) { FactoryGirl.create(:service) }
		let! (:middle) { FactoryGirl.create(:ride,
						    date: '2014/10/19',
						    service: service2) }
		let! (:last) { FactoryGirl.create(:ride,
						  date: '2014/10/26',
						  service: service1) }
		let! (:first) { FactoryGirl.create(:ride,
						   date: '2014/10/12',
						   service: service1) }

		before { visit rides_path(order: :Service) }

		it { should have_content(/#{last.date}.*#{first.date}.*#{middle.date}/) }
	    end
	end
    end
end
