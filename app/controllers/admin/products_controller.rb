class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i(show destroy edit update)
  before_action :find_all_category, only: %i(new create edit update)
  def index
    if params[:option]
      @pagy, @products = pagy(option_filter(params[:option]), items: 5)
    elsif params[:search]
      @pagy, @products = pagy(
        Product.all.sort_by_name(params[:search]),
        items: 5
      )
    else
      @pagy, @products = pagy(Product.all, items: 5)
    end
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new product_params
    if @product.save
      flash[:success] = t "admin.products.new.success"
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def show; end

  def destroy
    @product.destroy
    flash[:success] = "Delete success"
    redirect_to admin_products_path
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = "Updated success"
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  private
  def option_filter option
    options = Product::OPTION
    @products = case option.to_i
                when options[:oldest]
                  Product.all.order_by created_at: :asc
                when options[:newest]
                  Product.all.order_by created_at: :desc
                when options[:price_asc]
                  Product.all.order_by price: :asc
                when options[:price_desc]
                  Product.all.order_by price: :desc
                else
                  Product.all
                end
  end

  def find_product
    @product = Product.find_by id: params[:id]
    return if @product

    flash[:danger] = t "product.not_found"
    redirect_to admin_products_path
  end

  def find_all_category
    @category = Category.where("parent_id IS NOT NULL")
    return if @category

    flash[:danger] = t "admin.products.new.not_found"
    redirect_to admin_products_path
  end

  def product_params
    params.require(:product).permit(Product::PRO_ATS)
  end

  def product_nested_category_params
    params.require(:product).permit(
      :name, :price, :image, :quantity, :description, :rating,
      category_attributes: [:name, :parent_id]
    )
  end
end
