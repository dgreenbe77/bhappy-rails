class LocationsController < ApplicationController

  def create
    @location = Location.new(location_params)
    @user = current_user
    @info = Info.find_by(params[:info_id])
    @user.location = @location

    if @location.region == 'world'
      @location.delete
    end

    unless request.path == '/locations'
      if @location.save
        redirect_to @info
      else
        redirect_to @info
      end
    else
      if @location.save
        redirect_to '/world'
      else
        redirect_to '/world'
      end
    end
  end

  private

  def location_params
    params.require(:location).permit(:region)
  end

end
