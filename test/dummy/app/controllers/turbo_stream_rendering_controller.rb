class TurboStreamRenderingController < ApplicationController
  helper TurboStreamHelper
  def edit
    @state = State.find(params[:id])
  end

  def edit2
    @state = State.find(params[:id])
  end
end