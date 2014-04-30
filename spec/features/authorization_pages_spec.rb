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

	    it_behaves_like "redirects to a login", skip_browser: true do
		let (:direct_path) { user_path(user) }
		let (:direct_http_method) { :delete }
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

	    describe "delete action" do
		it_behaves_like "redirects to root", skip_browser: true do
		    let (:login_user) { user }
		    let (:error_type) { :danger }
		    let (:direct_http_method) { :delete }
		    let (:direct_path) { user_path(user) }
		end
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

		it_behaves_like "redirects to a login", skip_browser: true do
		    let (:direct_path) { user_path(user) }
		    let (:direct_http_method) { :delete }
		end
	    end
	end
    end

    describe "admin user" do
	let (:admin) { FactoryGirl.create(:admin) }

	describe "for Users controller" do
	    describe "delete action", type: :request do
		before do
		    login admin, avoid_capybara: true
		    delete user_path(user)
		    get response.headers['Location']
		end

		specify { expect(response.body).not_to have_alert(:danger) }
	    end
	end
    end
end
