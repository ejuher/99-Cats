class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  #protect_from_forgery with: :exception
  
  helper_method :current_user
  
  private
  
  def current_user
    puts session[:session_token]
    User.find_by_token(session[:session_token])
  end
end
