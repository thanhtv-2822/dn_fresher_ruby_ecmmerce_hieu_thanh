class Admin::StaticPagesController < Admin::BaseController
  def home; end

  def destroy
    log_out_admin
    redirect_to home_path
  end
end
