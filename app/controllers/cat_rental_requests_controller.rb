class CatRentalRequestsController < ApplicationController
  def new
    @cats = Cat.all
    render :new
  end
  
  def create
    @request = CatRentalRequest.new(req_params)
    
    if @request.save
      redirect_to cat_url(@request.cat)
    else
      render :new
    end
  end
  
  def approve
    @request = CatRentalRequest.find(params[:id])
    @request.approve!
    
    redirect_to cat_url(@request.cat)
  end
  
  def deny
    @request = CatRentalRequest.find(params[:id])
    @request.deny!
    
    redirect_to cat_url(@request.cat)
  end
  
  private
  
  def req_params
    params.require(:rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
