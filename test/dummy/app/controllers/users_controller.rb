class UsersController < ApplicationController
  before_action :set_user

  def update
    if @user.update user_params
      redirect_to prefilled_async_path, notice: "User updated"
    else
      head :unprocessable_entity
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params
        .require(:user)
        .permit(
          :favorite_state_id,
          :home_state_id,
          favorite_state_attributes: [:name],
          home_state_attributes: [:name])
    end
end
