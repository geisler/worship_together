require 'spec_helper'

feature 'HomePage' do
    before { visit root_path }

    subject { page }

    describe "the navigation bar" do
	it { should have_selector('nav.navbar') }

	it "has the proper links" do
	    within "nav.navbar" do
		should have_link('Worship Together', href: root_path)
		should have_link('Users', href: users_path)
		should have_link('Sign Up', href: new_user_path)
		should have_link('Log In', href: login_path)
		should_not have_link('Log Out', href: logout_path)
	    end
	end

	describe "logged in" do
	    let (:user) { FactoryGirl.create(:user) }

	    before do
		login user
		visit root_path
	    end

	    it "has the proper links" do
		within "nav.navbar" do
		    should have_link('Worship Together', href: root_path)
		    should have_link('Users', href: users_path)
		    should_not have_link('Sign Up', href: new_user_path)
		    should_not have_link('Log In', href: login_path)
		    should have_link('Log Out', href: logout_path)
		end
	    end
	end
    end

    describe "the content" do
	it { should have_selector('div.main.container') }
    end
end
