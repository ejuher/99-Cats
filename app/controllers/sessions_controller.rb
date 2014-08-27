class SessionsController < ApplicationController
  before_action :skip_if_logged_in , except: [:destroy]
  
  def create
    @user = User.find_by_credentials(
      params[:user][:user_name], params[:user][:password]
    )
    
    if @user
      login_user!
    else
      render :new
    end
  end
  
  def new
    render :new
  end
  
  def destroy
    current_user.reset_session_token!
    session[:session_token] = nil 
    
    render :new
  end
end
