module LoginsHelper
    def current_user
	User.find(session[:user_id]) if session[:user_id]
    end

    def current_user?(user)
	current_user == user
    end

    def logged_in?
	session[:user_id]
    end
end
