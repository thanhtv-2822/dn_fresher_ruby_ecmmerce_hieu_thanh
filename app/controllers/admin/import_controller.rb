class Admin::ImportController < Admin::BaseController
  before_action :check_extension, only: :create
  def new
    @product = Product.new
  end

  def create
    if @subject.blank?
      flash[:danger] = t "product.import_fail"
      render :new
    else
      flash[:info] = t("product.import_success",
                       success: @subject[:successes],
                       errors: @subject[:errors],
                       updates: @subject[:updates])
      redirect_to admin_products_path
    end
  end

  def check_extension
    extension = params[:file]&.content_type
    return if extension.nil?

    if [Settings.format.csv, Settings.format.xlsx].include? extension
      @subject = Product.import_file params[:file]
    else
      flash[:warning] = t "product.file_valid"
      render :new
    end
  end
end
