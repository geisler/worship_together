require 'spec_helper'

describe "Church Pages" do
    subject { page }

    describe "show churches" do
	describe "individually" do
	    let (:church) { FactoryGirl.create(:church) }
	    let! (:s) { FactoryGirl.create_list(:service, 10, church: church) }
	    let! (:t) { FactoryGirl.create_list(:service, 10) }
	    let! (:attendees) { FactoryGirl.create_list(:user, 25, church: church) }

	    before { visit church_path(church) }

	    it { should have_content(church.name) }
	    it { should have_link('official web site', href: church.web_site) }
	    it { should have_xpath('//img') } # church.picture
	    it { should have_content(church.description) }

	    it "should show connected services" do
		s.each do |service|
		    within("div.service#{service.id}") do
			have_content(service.start_time)
			have_content(service.finish_time)
			have_content(service.location)
			have_content(service.day_of_week)
		    end
		end
	    end

	    it "should not show services for other churches" do
		t.each do |service|
		    should_not have_selector("div.service#{service.id}")
		end
	    end

	    it "should show attendees" do
		attendees.each do |attendee|
		    within("div.user#{attendee.id}") do
			have_link(attendee.name, href: user_path(attendee))
		    end
		end
	    end
	end

	describe "non-existant", type: :request do
	    before { get church_path(-1) }

	    specify { expect(response).to redirect_to(churches_path) }

	    describe "follow redirect" do
		before { visit church_path(-1) }

		it { should have_alert(:danger, text: "Unable") }
	    end
	end

	describe "all" do
	    before do
		25.times { |i| FactoryGirl.create(:church) }
		visit churches_path
	    end

	    it { should have_content('List of churches') }
	    it { should have_content('25 churches') }

	    it "should show all churches" do
		Church.all.each do |church|
		    should have_selector('li', text: church.name)
		    should have_link(church.name, href: church_path(church))
		end
	    end
	end
    end

    describe "creating church" do
	let (:submit) { 'Create new church' }
	let (:user) { FactoryGirl.create(:user) }

	describe "not logged in", type: :request do
	    before { get new_church_path }

	    it "redirects to login page" do
		expect(response).to redirect_to(login_path)
	    end
	end

	describe "with invalid information" do
	    before do
		login user
		visit new_church_path
	    end

	    it "does not add the church to the system" do
		expect { click_button submit }.not_to change(Church, :count)
	    end

	    it "produces an error message" do
		click_button submit
		should have_alert(:danger)
	    end
	end

	describe "logged in user, with valid information" do
	    before do
		login user
		visit new_church_path
		fill_in 'Name', with: 'Church Name'
		fill_in 'Web site', with: 'http://www.example.com'
		fill_in 'Description', with: 'This is the church description.'
		fill_in 'Picture', with: 'Fake Picture' # change to file upload
		fill_in 'Start time', with: '9:00 AM'
		fill_in 'Finish time', with: '11:00 AM'
		fill_in 'Day of week', with: 'Sunday'
		fill_in 'Location', with: 'Somewhere important'
	    end

	    it "allows the user to fill in the fields" do
		click_button submit
	    end

	    it "does add the church to the system" do
		expect { click_button submit }.to change(Church, :count).by(1)
	    end

	    describe "produces a 'church created' message" do
		before { click_button submit }

		it { should have_alert(:success) }
	    end

	    describe "assigns the current user to be the church manager" do
		before { click_button submit }

		specify { expect(Church.last.user).to eql(user) }
	    end

	    describe "redirects to church profile page", type: :request do
		before do
		    login user, avoid_capybara: true
		    post churches_path,
			church: { name: 'Church Name',
				  web_site: 'http://www.example.com',
				  description: 'This is the church description.',
				  picture: 'Fake Picture', # change to file upload
				  services_attributes: {"0" => { start_time: '9:00 AM',
							 finish_time: '11:00 AM',
							 day_of_week: 'Sunday',
							 location: 'Somewhere important' } } }
		end

		specify do
		    expect(response).to redirect_to(church_path(assigns(:church)))
		end
	    end
	end
    end

    describe "editing churches" do
	let (:user) { FactoryGirl.create(:user) }
	let (:church) { FactoryGirl.create(:church, user: user) }
	let!(:original_name) { church.name }
	let (:submit) { 'Update church profile' }

	before do
	    login user
	    visit edit_church_path(church)
	end

	it { should have_field('Name', with: church.name) }
	it { should have_field('Picture') } # change to file upload
	it { should have_field('Web site', with: church.web_site) }
	it { should have_field('Description', with: church.description) }

	describe "with invalid information" do
	    before do
		fill_in 'Name', with: ''
	    end

	    describe "does not change data" do
		before { click_button submit }

		specify { expect(church.reload.name).not_to eq('') }
		specify { expect(church.reload.name).to eq(original_name) }
	    end

	    it "does not add a new church to the system" do
		expect { click_button submit }.not_to change(Church, :count)
	    end

	    it "produces an error message" do
		click_button submit
		should have_alert(:danger)
	    end
	end

	describe "non-existant", type: :request do
	    before do
		login user, avoid_capybara: true
		get edit_church_path(-1)
	    end

	    specify { expect(response).to redirect_to(churches_path) }

	    describe "follow redirect" do
		before { visit edit_church_path(-1) }

		it { should have_alert(:danger, text: "Unable") }
	    end
	end

	describe "with valid information" do
	    before do
		fill_in 'Name', with: 'New Church Name'
		fill_in 'Web site', with: 'http://www.example.com/new'
		fill_in 'Description', with: 'This is the NEW church description.'
		fill_in 'Picture', with: 'New Fake Picture' # change to file upload
		fill_in 'Start time', with: '7:00 PM'
		fill_in 'Finish time', with: '8:30 PM'
		fill_in 'Day of week', with: 'Saturday'
		fill_in 'Location', with: 'Somewhere casual'
	    end

	    describe "changes the data" do
		before { click_button submit }

		specify { expect(church.reload.name).to eq('New Church Name') }
		specify { expect(church.reload.web_site).to eq('http://www.example.com/new') }
		specify { expect(church.reload.description).to eq('This is the NEW church description.') }
		specify { expect(church.reload.services.first.start_time.strftime('%H:%M')).to eq('19:00') }
		specify { expect(church.reload.services.first.finish_time.strftime('%H:%M')).to eq('20:30') }
		specify { expect(church.reload.services.first.day_of_week).to eq('Saturday') }
		specify { expect(church.reload.services.first.location).to eq('Somewhere casual') }
	    end

	    describe "redirects back to church's profile page", type: :request do
		before do
		    login user, avoid_capybara: true
		    patch church_path(church),
			church: { name: 'New Church Name',
				  web_site: 'http://www.example.com/new',
				  description: 'This is the NEW church description.',
				  picture: 'New Fake Picture', # change to file upload
				  services_attributes: {"0" => { start_time: '7:00 PM',
							 finish_time: '8:30 PM',
							 day_of_week: 'Saturday',
							 location: 'Somewhere casual' } } }
		end

		specify { expect(response).to redirect_to(church_path(church)) }
	    end

	    it "produces an update message" do
		click_button submit
		should have_alert(:success)
	    end

	    it "does not add a new church to the system" do
		expect { click_button submit }.not_to change(Church, :count)
	    end
	end
    end

    describe "delete church" do
	let!(:church) { FactoryGirl.create(:church) }
	let (:admin) { FactoryGirl.create(:admin) }

	before do
	    login admin
	    visit churches_path
	end

	it { should have_link('delete', href: church_path(church)) }

	describe "redirects properly", type: :request do
	    before do
		login admin, avoid_capybara: true
		delete church_path(church)
	    end

	    specify { expect(response).to redirect_to(churches_path) }
	end

	it "produces a delete message" do
	    click_link('delete', match: :first)
	    should have_alert(:success)
	end

	it "removes a church from the system" do
	    expect do
		click_link('delete', match: :first)
	    end.to change(Church, :count).by(-1)
	end
    end
end
