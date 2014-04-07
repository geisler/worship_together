class UsersController < ApplicationController
    def index
	@users = User.all
    end

    def new
	@user = User.new
    end

    def create
	@user = User.new(user_params)
	if @user.save
	    flash[:success] = "Welcome to the site, #{@user.name}"
	    redirect_to @user
	else
	    flash.now[:danger] = "Unable to create new user"
	    render 'new'
	end
    end

    def show
	@user = User.find(params[:id])
    rescue
	flash[:danger] = "Unable to find user"
	redirect_to users_path
    end

    def edit
    rescue
	flash[:danger] = "Unable to find user"
	redirect_to users_path
    end

    private

    def user_params
	params.require(:user).permit(:name, :email, :password)
    end
end
