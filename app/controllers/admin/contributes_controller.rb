class Admin::ContributesController < Admin::BaseController
  authorize_resource

  def index
    if params[:option]
      @pagy, @contributes = pagy(
        filter_option(params[:option]),
        items: Settings.page.size_5
      )
    else
      @pagy, @contributes = pagy(
        Contribute.all,
        items: Settings.page.size_5
      )
    end
  end

  def show
    @contribute = Contribute.find_by id: params[:id]
    return if @contribute

    flash[:danger] = t "admin.contrib.not_found"
    redirect_to admin_contributes_path
  end

  def update
    @contribute = Contribute.find_by id: params[:id]
    if @contribute
      @contribute.update status: 1
      UserMailer.suggestion(@contribute).deliver_now
    else
      flash[:danger] = t "admin.contrib.not_found"
    end
    redirect_to admin_contributes_path
  end

  private
  def filter_option option
    contrib = Settings.admin.contribute
    case option.to_i
    when contrib.accept
      Contribute.filter_accept
    when contrib.pending
      Contribute.filter_pending
    else
      Contribute.all
    end
  end
end
