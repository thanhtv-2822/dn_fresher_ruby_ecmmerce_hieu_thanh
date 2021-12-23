class Admin::CategoriesController < Admin::BaseController
  before_action :find_category, except: %i(index new create)
  def index
    @pagy, @category = pagy(Category.all, items: 10)
  end

  def show
    @pagy, @cate_child = pagy(
      Category.where(parent_id: @category.id),
      items: 10
    )
  end

  def edit; end

  def new
    @category = Category.new
  end
  
  def create
    @category = Category.new category_params
    if @category.save
      flash[:success] = "Create category successfuly"
      redirect_to admin_categories_path
    else
      render :new
    end
  end

  def update
    if @category.update category_params
      flash[:success] = "Update category successfuly"
    else
      flash[:success] = "Update category fails"
    end
    if @category.parent_id.nil?
      redirect_to admin_categories_path
    else
      redirect_to admin_category_path @category.parent_id
    end
  end

  def destroy
    @category.destroy
    flash[:success] = "Remove category successfuly"
    if @category.parent_id.nil?
      redirect_to admin_categories_path
    else
      admin_category_path @category.parent_id
    end
  end

  private
  def find_category
    @category = Category.find_by id: params[:id]
    return if @category

    flash[:success] = "Category not found"
    redirect_to admin_category_index_path
  end

  def category_params
    params.require(:category).permit(Category::CATE_ATTRS)
  end
end
