class LocationsController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery with: :exception

  def create
    @location = Location.new(location_params)
    @user = current_user
    @happiness_log = HappinessLog.find_by(params[:happiness_log_id])
    @user.location = @location

    if @location.region == 'world'
      @location.delete
    end

    if params["commit"] == "Change Region"
      if @location.save
        redirect_to @happiness_log
      else
        redirect_to @happiness_log
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
