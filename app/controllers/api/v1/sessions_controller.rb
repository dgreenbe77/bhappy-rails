class Api::V1::SessionsController < ApplicationController
  protect_from_forgery except: [:create, :destroy]

  def create
    # warden.authenticate!(:scope => :user, :store => false, :recall => "#{controller_path}#failure")
    @user = User.find_for_authentication(email: params[:user][:email])
    if @user && @user.valid_password?(params[:user][:password])
      render :status => 200,
       :json => { :success => true,
                  :info => "Logged in",
                  :data => { :auth_token => @user.authentication_token } }      
    end
  end

  def destroy
    # warden.authenticate!(:scope => :user, :store => false, :recall => "#{controller_path}#failure")
    current_user.reset_authentication_token!
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

end
