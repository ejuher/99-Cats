class SessionsController < ApplicationController
  def create
    user = User.find_by_credentials(
      params[:user][:user_name], params[:user][:password]
    )
    if user
      #reset session token
      user.reset_session_token!
      
      #update the session
      session[:session_token] = user.session_token
      
      redirect_to cats_url
    else
      render :new
    end
  end
  
  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil 
    
    render :new
  end
  
  
end
