class ContributesController < ApplicationController
  before_action :logged_in_user, only: %i(index new create)
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
      flash[:success] = t "info.contribute"
      redirect_to contributes_path
    else
      render :new
    end
  end

  private

  def contribute_params
    params.require(:contribute).permit(Contribute::CONT_ATT)
  end
end
