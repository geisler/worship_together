def login(user, options = {})
#    if example.metadata[:type] == :request
    if options[:avoid_capybara]
	post logins_path, username: user.name, password: user.password
    else
	visit login_path
	fill_in 'Username', with: user.name
	fill_in 'Password', with: user.password
	click_button 'Log In'
    end
end

def expect_redirect_with_alert(path, alert_type)
    expect(response).to redirect_to(path)
    get path
    expect(response.body).to have_alert(alert_type)
end

shared_examples "redirects to a login" do |options|
    options ||= {}
    options.merge!(skip_browser: false, direct_access: true) {|k, v1, v2| v1}

    unless options[:skip_browser]
	describe "visit browser path" do
	    before { visit browser_path }

	    it { should have_alert(:warning) }
	    it { should have_content('Sign In') }
	end
    end

    if options[:direct_access]
	describe "direct visit to HTTP path", type: :request do
	    before { send(direct_http_method, direct_path) }

	    specify { expect_redirect_with_alert(login_path, :warning) }
	end
    end
end

shared_examples "redirects to root" do |options|
    options ||= {}
    options.merge!(skip_browser: false, direct_access: true) {|k, v1, v2| v1}

    before { login login_user, avoid_capybara: true }

    unless options[:skip_browser]
	describe "visit browser path", type: :request do
	    before { get browser_path }

	    specify { expect(response.body).not_to match(error_signature) }
	    specify { expect_redirect_with_alert(root_path, error_type) }
	end
    end

    if options[:direct_access]
	describe "direct visit to HTTP path", type: :request do
	    before { send(direct_http_method, direct_path) }

	    specify { expect_redirect_with_alert(root_path, error_type) }
	end
    end
end
