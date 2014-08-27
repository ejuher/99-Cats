class CatsController < ApplicationController
  before_action :prevent_unauthorized_updates, only: [:edit, :update, :destroy]
  
  def index
    @cats = Cat.all.order(:name)
    render :index
  end
  #
  # def request_rental
  #   @cat = Cat.find(params[:id])
  #   @request = CatRentalRequest.new(cat_id: @cat.id)
  #
  #   redirect_to cat_url(@cat)
  # end
  
  def show
    @request = CatRentalRequest.new(cat_id: current_cat.id)
    @requests = current_cat.rental_requests.order(:start_date)
    @display_attrs = current_cat.attributes.except(
      "id", "created_at", "updated_at", "name", "description"
    )
    render :show
  end
  
  def new
    @cat = Cat.new
    render :new
  end
  
  def edit
    current_cat
    render :edit
  end
  
  def create
    @cat = Cat.new(cat_params)
    
    if @cat.save
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end
  
  def update    
    if current_cat.update(cat_params)
      redirect_to cat_url(current_cat)
    else
      render :update
    end
  end
  
  private
  
  def current_cat
    @cat ||= Cat.find(params[:id])
  end
  
  def cat_params
    cat_params = params.require(:cat).permit(
      :name, :age, :sex, :color, :birth_date, :description
    )
    
    cat_params[:user_id] = current_user.id
    cat_params
  end
  
  def prevent_unauthorized_updates
    redirect_to cats_url if current_cat.owner != current_user
  end
end
