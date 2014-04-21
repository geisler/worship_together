class LoginsController < ApplicationController
    def new
    end

    def create
	user = User.find_by(name: params[:username])
	if user && user.password == params[:password]
	    flash[:success] = 'Logged in'
	    redirect_to users_path
	else
	    flash.now[:danger] = 'Invalid username or password'
	    render 'new'
	end
    end
end
