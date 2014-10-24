require 'spec_helper'

describe 'Service Pages' do
    subject { page }

    describe "show services" do
	describe "all" do
	    before do
		25.times { FactoryGirl.create(:service) }
		visit services_path
	    end

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
		let! (:wed) { FactoryGirl.create(:service, day_of_week: 'Wednesday') }
		let! (:sat) { FactoryGirl.create(:service, day_of_week: 'Saturday') }
		let! (:sun) { FactoryGirl.create(:service, day_of_week: 'Sunday') }

		before { visit services_path(order: :Day) }

		it { should have_content(/#{sun.day_of_week}.*#{wed.day_of_week}.*#{sat.day_of_week}/) }
	    end

	    describe "by time of day" do
		let! (:normal) { FactoryGirl.create(:service, start_time: '9:00 AM') }
		let! (:early) { FactoryGirl.create(:service, start_time: '6:00 AM') }
		let! (:late) { FactoryGirl.create(:service, start_time: '6:00 PM') }

		before { visit services_path(order: :Time) }

		it { should have_content(/#{early.start_time}.*#{normal.start_time}.*#{late.start_time}/) }
	    end
	end
    end
end
