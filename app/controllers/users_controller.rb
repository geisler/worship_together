class UsersController < ApplicationController
    def index
	@users = User.all
    end

    def new
	@user = User.new
    end

    def create
	user = User.new(params.require(:user).permit(:name, :email, :password))
	if user.save
	    flash[:success] = "Welcome to the site, #{user.name}"
	else
	    flash[:danger] = "Unable to create new user"
	end
	redirect_to users_path
    end
end
