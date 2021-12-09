class CartsController < ApplicationController
  before_action :find_product, except: :index
  before_action :find_item, except: %i(index create)
  before_action :logged_in_user, only: %i(index create)
  before_action :check_quantity_update, only: :update_cart
  before_action :check_quantity_add, only: :create

  def index
    @carts = get_all_item_in_cart
  end

  def create
    if @item
      @item["quantity"] += params[:quantity].to_i
      flash[:success] = t "errors.carts.update"
    else
      current_cart << {
        product_id: @product.id,
        quantity: params[:quantity].to_i,
        rating: 0
      }
      flash[:success] = t "errors.carts.add"
    end
    session[:cart] = current_cart
    redirect_to product_path
  end

  def destroy
    current_cart.delete @item
    flash[:success] = t "errors.carts.remove"
    redirect_to carts_path
  end

  def update_cart
    @item["quantity"] = params[:quantity].to_i
    flash[:success] = t "errors.carts.update_qty"
    redirect_to carts_path
  end

  def update_rating_item
    @item["rating"] = params[:rating].to_i
    flash[:success] = t "errors.carts.review_success"
    redirect_to carts_path
  end

  private
  def find_product
    @product = Product.find_by(id: params[:id])
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to root_path
  end

  def find_item
    @item = find_product_in_cart @product
    return if @item

    flash[:danger] = t "carts.item.not_found"
    redirect_to root_path
  end

  def check_quantity_update
    return if params[:quantity].to_i.positive? &&
              params[:quantity].to_i <= @product.quantity

    quantity_valid params[:quantity]
    redirect_to carts_path
  end

  def check_quantity_add
    return if @item.nil? ||
              params[:quantity].to_i +
              @item[:quantity] <= @product.quantity

    quantity_valid params[:quantity]
    redirect_to product_path(@item[:product].id)
  end

  def quantity_valid quantity
    flash[:danger] = if quantity.to_i.negative?
                       t "carts.quantity.not_valid"
                     else
                       t "errors.carts.enough"
                     end
  end
end
