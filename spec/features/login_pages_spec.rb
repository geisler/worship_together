require 'spec_helper'

describe "LoginPages" do
    subject { page }

    describe "SignIn page" do
	before { visit login_path }

	it { should have_content('Sign In') }

	describe "with invalid account information" do
	    before { click_button 'Log In' }

	    it { should have_alert(:danger, text: 'Invalid') }

	    describe "with bad password" do
		let (:user) { FactoryGirl.create(:user) }

		before do
		    fill_in 'Username', with: user.name
		    fill_in 'Password', with: 'garbage'
		    click_button 'Log In'
		end

		it { should have_alert(:danger, text: 'Invalid') }
	    end
	end

	describe "with valid account information" do
	    let (:user) { FactoryGirl.create(:user) }

	    before do
		fill_in 'Username', with: user.name
		fill_in 'Password', with: user.password
		click_button 'Log In'
	    end

	    it { should have_link('Log Out', href: logout_path) }
	    it { should_not have_link('Log In', href: login_path) }
	    it { should have_alert(:success) }

	    describe "followed by logout" do
		before { click_link 'Log Out' }

		it { should have_link('Log In', href: login_path) }
		it { should_not have_link('Log Out', href: logout_path) }
		it { should have_alert(:info) }
	    end
	end
    end
end
