class SessionsController < ApplicationController
  def create
    user = FacebookUser.from_omniauth(env["omniauth.auth"])
    session[:facebook_user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:facebook_user_id] = nil
    redirect_to root_url
  end
end
