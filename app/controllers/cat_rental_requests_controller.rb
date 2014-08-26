class CatRentalRequestsController < ApplicationController
  def new
    @cats = Cat.all
    render :new
  end
  
  def create
    @request = CatRentalRequest.new(req_params)
    
    if @request.save
      redirect_to cats_url
    else
      render :new
    end
  end
  
  def req_params
    params.require(:rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
