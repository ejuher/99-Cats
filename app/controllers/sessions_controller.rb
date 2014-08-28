class SessionsController < ApplicationController
  before_action :skip_if_logged_in, except: [:destroy, :index]
  before_action :prevent_unauthorized_logouts, only: [:destroy]
  before_action :ensure_logged_in, only: [:destroy, :index]
  
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
    #current_user.reset_session_token!
    
    # token = session[:session_token]
#     Session.find_by_token(token).destroy
#     session[:session_token] = nil
    current_session.destroy

    if current_session.id == current_user.session_id
      render :new
    else
      redirect_to sessions_url
    end
  end
  
  def index
    @sessions = Session.where(user_id: current_user.id)
    render :index
  end
  
  private
  
  def current_session
    @current_session ||= Session.find(params[:id])
  end
  
  def prevent_unauthorized_logouts
    unless current_user.sessions.include? current_session
      redirect_to cats_url 
    end
  end 
  
  def ensure_logged_in
    if current_user.nil?
      redirect_to new_session_url
    end
  end 
  
end
