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
	    describe "new action" do
		it_behaves_like "redirects to root" do
		    let (:login_user) { user }
		    let (:browser_path) { new_user_path }
		    let (:error_type) { :warning }
		    let (:error_signature) { 'Sign up' }
		    let (:direct_http_method) { :post }
		    let (:direct_path) { users_path }
		end
	    end

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
		let (:login_user) { FactoryGirl.create(:user) }
		let (:error_type) { :danger }

		it_behaves_like "redirects to root" do
		    let (:browser_path) { edit_user_path(user) }
		    let (:error_signature) { 'Edit profile' }
		    let (:direct_path) { user_path(user) }
		    let (:direct_http_method) { :patch }
		end

		it_behaves_like "redirects to root", skip_browser: true do
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

	    describe "delete action (self)", type: :request do
		it_behaves_like "redirects to root", skip_browser: true do
		    let (:login_user) { admin }
		    let (:error_type) { :danger }
		    let (:direct_path) { user_path(admin) }
		    let (:direct_http_method) { :delete }
		end
	    end
	end
    end
end
