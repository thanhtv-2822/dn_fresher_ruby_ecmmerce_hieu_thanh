class Admin::UsersController < Admin::BaseController
  before_action :check_user, only: [:edit, :update, :destroy]
  def index
    @pagy, @users = pagy(
      User.all.order_by_updated_at,
      items: 5
    )
    filter_params(params).each do |key, value|
      @users = @users.public_send("filter_by_#{key}", value) if value.present?
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t "success.user"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "success.user_delete"
    else
      flash[:danger] = t "errors.delete"
    end
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(User::USER_ATTRS)
  end

  def filter_params params
    params.slice(:name)
  end

  def check_user
    return if @user = User.find_by(id: params[:id])

    flash[:danger] = t "errors.user"
  end
end
