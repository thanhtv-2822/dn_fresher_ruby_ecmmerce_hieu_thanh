class ContributesController < ApplicationController
  before_action :check_logged_in?, only: %i(index new create )
  def new
    @contribute = Contribute.new
  end

  def index
    @contributes = current_user.contributes.order(created_at: "DESC")
  end

  def create
    @contribute = current_user.contributes.build(contribute_params)
    @contribute.image.attach(contribute_params[:image])
    if @contribute.save
      flash[:success] = "Thanks your contribute"
      redirect_to user_contributes_path(current_user)
    else
      render :new
    end
  end

  private

  def contribute_params
    params.require(:contribute).permit(Contribute::CONT_ATT)
  end

  def check_logged_in?
    return if logged_in?

    redirect_back_or login_path
  end
end
