class CartsController < ApplicationController
  before_action :find_product,
                :find_item,
                only: %i(
                  add_item_to_cart
                  remove_item_in_cart
                  update_cart
                  update_rating_item
                )
  before_action :logged_in_user, only: %i(index add_item_to_cart)
  before_action :check_quantity, only: :update_cart

  def index
    @carts = get_all_item_in_cart
  end

  def add_item_to_cart
    if @item
      @item["quantity"] += params[:quantity].to_i
      flash[:success] = "Update product to cart success"
    else
      current_cart << {
        product: @product,
        quantity: params[:quantity].to_i,
        rating: 0
      }
      flash[:success] = "Add product to cart success"
    end
    session[:cart] = current_cart
    redirect_to product_path
  end

  def remove_item_in_cart
    if @item
      current_cart.delete @item
      flash[:success] = "Remove item success"
    end
    redirect_to carts_path
  end

  def update_cart
    if @item
      @item["quantity"] = params[:quantity].to_i
      flash[:success] = "Update cart successfully"
    else
      flash[:danger] = "Update cart fail"
    end
    redirect_to carts_path
  end

  def update_rating_item
    if @item
      @item["rating"] = params[:rating].to_i
      flash[:success] = "Review successfully"
    else
      flash[:danger] = "Review fail"
    end
    redirect_to carts_path
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])
  end

  def find_item
    @item = find_product_in_cart @product
  end

  def check_quantity
    return unless params["quantity"].to_i > @item["product"]["quantity"]

    flash[:danger] = "Product quantity not enough"
    redirect_to carts_path
  end
end
