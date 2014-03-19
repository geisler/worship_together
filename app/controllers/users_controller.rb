class UsersController < ApplicationController
    def index
	@users = User.all
    end

    def new
	@user = User.new
    end

    def create
	user = User.create(params.require(:user).permit(:name, :email, :password))
	flash[:success] = "Welcome to the site, #{user.name}"
	redirect_to users_path
    end
end
