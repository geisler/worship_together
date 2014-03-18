require 'spec_helper'

describe "User Pages" do
    subject { page }

    describe "show users" do
	describe "all" do
	    before do
		25.times { |i| FactoryGirl.create(:user) }
		visit users_path
	    end

	    it { should have_content('List of users') }
	    it { should have_content('25 users') }

	    it "should show all users" do
		User.all.each do |user|
		    should have_selector('li', text: user.name)
		    should have_selector('li', text: user.email)
		end
	    end
	end
    end

    describe "creating user" do
	before { visit new_user_path }

	it "hides password text" do
	    should have_field 'user_password', type: 'password'
	end

	describe "with invalid information" do
	    it "does not add the user to the system" do
		expect { click_button 'Submit' }.not_to change(User, :count)
	    end

	    it "produces an error message" do
		click_button 'Submit'
		should have_alert(:danger)
	    end
	end

	describe "with valid information" do
	    before do
		fill_in 'Username', with: 'John Doe'
		fill_in 'Email', with: 'john.doe@example.com'
		fill_in 'Password', with: 'password'
	    end

	    it "allows the user to fill in the fields" do
		click_button 'Submit'
	    end

	    it "does add the user to the system" do
		expect { click_button 'Submit' }.to change(User, :count).by(1)
	    end

	    describe "produces a welcome message" do
		before { click_button 'Submit' }

		it { should have_alert(:success, text: 'Welcome') }
	    end
	end
    end
end
