require 'spec_helper'

describe 'AuthorizationPages' do
    subject { page }

    let (:user) { FactoryGirl.create(:user) }

    describe "non-authenticated users" do
	describe "for Users controller" do
	    it_behaves_like "redirects to a login" do
		let (:browser_path) { edit_user_path(user) }
		let (:direct_path) { user_path(user) }
		let (:direct_http_method) { :patch }
	    end
	end
    end

    describe "authenticated users" do
	describe "for Users controller" do
	    describe "edit action" do
		before do
		    login(user)
		    visit edit_user_path(user)
		end

		it { should_not have_alert(:warning) }
		it { should have_content('Edit profile') }
	    end
	end
    end

    describe "authenticated, but wrong users" do
	describe "for Users controller" do
	    describe "edit action" do
		let (:other_user) { FactoryGirl.create(:user) }

		before { login other_user }

		it_behaves_like "redirects to a login" do
		    let (:browser_path) { edit_user_path(user) }
		    let (:direct_path) { user_path(user) }
		    let (:direct_http_method) { :patch }
		end
	    end
	end
    end
end
