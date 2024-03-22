class VisitsController < ApplicationController
  before_action :set_user

  def create
    User.transaction do
      @states = find_or_create_states!
      @user.update! visited_states: @states
    end

    redirect_back_or_to multiselect_new_values_path, notice: "Visits created"
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def find_or_create_states!
      @states = params[:user][:visited_states].split(",").map do |value|
        State.find_by(id: value) || State.create!(name: value)
      end
    end
end
