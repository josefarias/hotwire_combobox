class UsersController < ApplicationController
  before_action :set_user

  def update
    if @user.update user_params.merge(visited_state_ids: visited_state_ids)
      redirect_back_or_to prefilled_async_path, notice: "User updated"
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
          favorite_state_attributes: %i[ name ],
          home_state_attributes: %i[ name ])
    end

    def visited_state_ids
      params[:user][:visited_state_ids].split(",")
    end
end
