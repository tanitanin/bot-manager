class SessionsController < ApplicationController
  def create
    auth = request.env["omniauth.auth"]

    session[:user_id] = User.create_session_with_auth(auth)
    redirect_to root_url, :notice => "Signed In!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Signed Out!"
  end
end
