def login(user)
    visit login_path
    fill_in 'Username', with: user.name
    fill_in 'Password', with: user.password
    click_button 'Log In'
end

shared_examples "redirects to a login" do |options|
    options ||= {}

    describe "visit browser path" do
	before { visit browser_path }

	it { should have_alert(:warning) }
	it { should have_content('Log In') }
    end
end
