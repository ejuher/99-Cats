class UsersController < ApplicationController
  before_action :skip_if_logged_in
  
  def new
    render :new
  end
  
  def create
    @user = User.new(user_params)
    
    if @user.save
      login_user!
    else
      render :new
    end
  end
  
  private
  
  def user_params
    params.require(:user).permit(:user_name, :password)
  end
end
