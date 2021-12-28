class Admin::ProductsController < Admin::BaseController
  before_action :find_product, only: %i(show destroy edit update)
  before_action :find_all_category, except: %i(index show)
  def index
    if params[:option]
      find_products_with_option params[:option]
    elsif params[:search]
      find_products_with_search params[:search]
    else
      @pagy, @products = pagy(Product.all, items: Settings.page.size_5)
    end
  end

  def new
    @product = Product.new
    @product.build_category if @product.build_category.blank?
  end

  def create
    @product = if product_params[:category_id].blank?
                 Product.new product_params
               else
                 Product.new product_params_has_category
               end
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
    flash[:success] = t "admin.products.delete"
    redirect_to admin_products_path
  end

  def edit; end

  def update
    if @product.update product_params
      flash[:success] = t "admin.products.update"
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  private
  def find_products_with_option option
    @pagy, @products = pagy(
      option_filter(option),
      items: Settings.page.size_5
    )
  end

  def find_products_with_search keyword
    @pagy, @products = pagy(
      Product.all.sort_by_name(keyword),
      items: Settings.page.size_5
    )
  end

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
    @category_child = Category.where("parent_id IS NOT NULL")
    return if @category_child

    flash[:danger] = t "admin.products.new.not_found"
    redirect_to admin_products_path
  end

  def product_params
    params.require(:product).permit(
      Product::PRO_ATS,
      category_attributes: Category::CATE_ATTRS
    )
  end

  def product_params_has_category
    params.require(:product).permit(Product::PRO_ATS)
  end
end
