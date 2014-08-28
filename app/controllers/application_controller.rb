class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  
  private
  
  def login_user!
    session[:session_token] = Session.add_token_for_user(
      @user, request.env["HTTP_USER_AGENT"], request.remote_ip
    )
    
    # @user.reset_session_token!
    # session[:session_token] = @user.session_token
    
    redirect_to cats_url
  end
  
  def current_user
    @user ||= User.find_by_token(session[:session_token])
  end
  
  def skip_if_logged_in
    redirect_to cats_url if current_user
  end
end
