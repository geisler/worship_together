require 'spec_helper'

describe "Church Pages" do
    subject { page }

    describe "show churches" do
	describe "individually" do
	    let (:church) { FactoryGirl.create(:church) }

	    before { visit church_path(church) }

	    it { should have_content(church.name) }
	    it { should have_link('official web site', href: church.web_site) }
	    it { should have_xpath('//img') } # church.picture
	    it { should have_content(church.description) }
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

#    describe "editing users" do
#	let (:user) { FactoryGirl.create(:user) }
#	let!(:original_name) { user.name }
#	let (:submit) { 'Update user profile' }
#
#	before do
#	    login user
#	    visit edit_user_path(user)
#	end
#
#	it { should have_field('Username', with: user.name) }
#	it { should have_field('Email', with: user.email) }
#	it { should have_field('Password') }
#
#	describe "with invalid information" do
#	    before do
#		fill_in 'Username', with: ''
#		fill_in 'Email', with: ''
#		fill_in 'Password', with: ''
#	    end
#
#	    describe "does not change data" do
#		before { click_button submit }
#
#		specify { expect(user.reload.name).not_to eq('') }
#		specify { expect(user.reload.name).to eq(original_name) }
#	    end
#
#	    it "does not add a new user to the system" do
#		expect { click_button submit }.not_to change(User, :count)
#	    end
#
#	    it "produces an error message" do
#		click_button submit
#		should have_alert(:danger)
#	    end
#	end
#
#	describe "non-existant", type: :request do
#	    before do
#		login user, avoid_capybara: true
#		get edit_user_path(-1)
#	    end
#
#	    specify { expect(response).to redirect_to(users_path) }
#
#	    describe "follow redirect" do
#		before { visit edit_user_path(-1) }
#
#		it { should have_alert(:danger, text: "Unable") }
#	    end
#	end
#
#	describe "with valid information" do
#	    before do
#		fill_in 'Username', with: 'New Name'
#		fill_in 'Email', with: 'new.name@example.com'
#		fill_in 'Password', with: user.password
#		fill_in 'Confirmation', with: user.password
#	    end
#
#	    describe "changes the data" do
#		before { click_button submit }
#
#		specify { expect(user.reload.name).to eq('New Name') }
#		specify { expect(user.reload.email).to eq('new.name@example.com') }
#	    end
#
#	    describe "redirects back to profile page", type: :request do
#		before do
#		    login user, avoid_capybara: true
#		    patch user_path(user), user: { name: 'New Name',
#						   email: 'new.name@example.com',
#						   password: user.password,
#						   password_confirmation: user.password }
#		end
#
#		specify { expect(response).to redirect_to(user_path(user)) }
#	    end
#
#	    it "produces an update message" do
#		click_button submit
#		should have_alert(:success)
#	    end
#
#	    it "does not add a new user to the system" do
#		expect { click_button submit }.not_to change(User, :count)
#	    end
#	end
#    end
#
#    describe "delete users" do
#	let!(:user) { FactoryGirl.create(:user) }
#	let (:admin) { FactoryGirl.create(:admin) }
#
#	before do
#	    login admin
#	    visit users_path
#	end
#
#	it { should have_link('delete', href: user_path(user)) }
#
#	describe "redirects properly", type: :request do
#	    before do
#		login admin, avoid_capybara: true
#		delete user_path(user)
#	    end
#
#	    specify { expect(response).to redirect_to(users_path) }
#	end
#
#	it "produces a delete message" do
#	    click_link('delete', match: :first)
#	    should have_alert(:success)
#	end
#
#	it "removes a user from the system" do
#	    expect do
#		click_link('delete', match: :first)
#	    end.to change(User, :count).by(-1)
#	end
#    end
end
