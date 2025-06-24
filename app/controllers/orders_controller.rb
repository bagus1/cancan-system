class OrdersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource  # CanCanCan magic - loads @order/@orders and authorizes actions
  
  def index
    # @orders already loaded and filtered by CanCanCan based on user abilities
    @orders = @orders.includes(:user).order(created_at: :desc)
  end

  def show
    # @order already loaded and authorized by CanCanCan
  end

  def process_order
    @order.user = current_user
  end

  def new
    # @order already initialized by CanCanCan
    @order.user = current_user
  end

  def create
    @order.user = current_user
    
    if @order.save
      redirect_to @order, notice: 'Order was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @order already loaded and authorized by CanCanCan
  end

  def update
    if @order.update(order_params)
      redirect_to @order, notice: 'Order was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_url, notice: 'Order was successfully deleted.'
  end

  private

  def order_params
    params.require(:order).permit(:total, :status)
  end
end
