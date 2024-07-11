class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: %i[edit update destroy]

  def index
    @users = User.default_order.page(params[:page])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admins_users_path, notice: t('controllers.updated')
    else
      flash[:alert] = t('controllers.failed')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @user.destroy!
    redirect_to admins_users_path, notice: t('controllers.destroyed')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
