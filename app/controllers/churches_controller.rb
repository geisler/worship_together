class ChurchesController < ApplicationController
    def new
	@church = Church.new
	@church.services.build
    end

    def create
	@church = Church.new(church_params)
	@church.user = current_user
	if @church.save
	    flash[:success] = "Church created"
	    redirect_to @church
	else
	    flash.now[:danger] = "Unable to create church"
	    render 'new'
	end
    end

    private

    def church_params
	params.require(:church).permit(:name,
				       :web_site,
				       :description,
				       :picture,
				       services_attributes: [ :start_time,
							      :finish_time,
							      :location ] )
    end
end
