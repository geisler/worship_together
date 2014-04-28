require 'spec_helper'

describe 'AuthorizationPages' do
    subject { page }

    let (:user) { FactoryGirl.create(:user) }

    describe "non-authenticated users" do
	describe "for Users controller" do
	    describe "edit action" do
		before { visit edit_user_path(user) }

		it { should have_alert(:warning) }
		it { should have_content('Log In') }
	    end
	end
    end

    describe "authenticated users" do
	describe "for Users controller" do
	    describe "edit action" do
		before do
		    visit login_path
		    fill_in 'Username', with: user.name
		    fill_in 'Password', with: user.password
		    click_button 'Log In'

		    visit edit_user_path(user)
		end

		it { should_not have_alert(:warning) }
		it { should have_content('Edit profile') }
	    end
	end
    end
end
