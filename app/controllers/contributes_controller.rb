class ContributesController < ApplicationController

  def new
    @contribute = Contribute.new
  end

  def show
    @contributes = @user.contributes
  end

  def create
    @contribute = @user.contributes.build(contribute_params)
    @contribute.image.attach(contribute_params[:image])
    if @contribute.save
      flash[:success] = "Thanks your contribute"
    else
      render :show
    end
  end

  private

  def contribute_params
    params.require(:contribute).permit(Contribute::CONT_ATT)
  end
end
