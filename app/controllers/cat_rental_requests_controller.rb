class CatRentalRequestsController < ApplicationController
  before_action :prevent_unauthorized_approval, only: [:approve, :deny]
  
  def new
    @cats = Cat.all
    render :new
  end
  
  def create
    @request = CatRentalRequest.new(req_params)
    
    @request.save
    
    redirect_to cat_url(@request.cat)
  end
  
  def approve
    current_request.approve!
    
    redirect_to cat_url(current_request.cat)
  end
  
  def deny
    current_request.deny!
    
    redirect_to cat_url(current_request.cat)
  end
  
  private
  
  def current_request
    @request ||= CatRentalRequest.find(params[:id])
  end
  
  def prevent_unauthorized_approval
    if current_request.cat_owner != current_user
      redirect_to cat_url(current_request.cat.id) 
    end
  end
  
  def req_params
    req_params = params.require(:rental_request).permit(:cat_id, :start_date, :end_date)
    req_params[:user_id] = current_user.id
    req_params
  end
end
