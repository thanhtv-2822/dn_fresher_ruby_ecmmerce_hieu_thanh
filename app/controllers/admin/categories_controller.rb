class Admin::CategoriesController < Admin::BaseController
  authorize_resource

  before_action :find_category, except: %i(index new create)
  def index
    @pagy, @category = pagy(Category.all, items: Settings.page.size_5)
  end

  def show
    @pagy, @cate_child = pagy(
      Category.where(parent_id: @category.id),
      items: Settings.page.size_5
    )
  end

  def edit; end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = t "admin.category.new"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def update
    if @category.update category_params
      flash[:success] = t "admin.category.update.success"
    else
      flash[:danger] = t "admin.category.update.fail"
    end

    if @category.parent_id.nil?
      redirect_to admin_categories_path
    else
      redirect_to admin_category_path @category.parent_id
    end
  end

  def destroy
    @category.destroy
    flash[:success] = t "admin.category.remove"
    if @category.parent_id.nil?
      redirect_to admin_categories_path
    else
      redirect_to admin_category_path(@category.parent_id)
    end
  end

  private
  def find_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:success] = t "admin.category.not_found"
    redirect_to admin_categories_path
  end

  def category_params
    params.require(:category).permit(Category::CATE_ATTRS)
  end
end
