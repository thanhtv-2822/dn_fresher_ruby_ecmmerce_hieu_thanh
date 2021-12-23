class Admin::ContributesController < Admin::BaseController
  def index
    if params[:option]
      @pagy, @contributes = pagy(
        filter_option(params[:option]),
        items: 5
      )
    else
      @pagy, @contributes = pagy(Contribute.all, items: 5)
    end
  end

  def show
    @contribute = Contribute.find_by id: params[:id]
    return if @contribute

    flash[:danger] = "Can not found contribute"
    redirect_to admin_contributes_path
  end

  def update
    @contribute = Contribute.find_by id: params[:id]
    if @contribute
      @contribute.update status: 1
      UserMailer.suggestion(@contribute).deliver_now
    else
      flash[:danger] = "Can not found contribute"
    end
    redirect_to admin_contributes_path
  end

  private
  def filter_option option
    case option.to_i
    when 2
      Contribute.filter_accept
    when 3
      Contribute.filter_pending
    else
      Contribute.all
    end
  end
end
