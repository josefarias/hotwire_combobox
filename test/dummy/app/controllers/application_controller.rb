class ApplicationController < ActionController::Base
  private

    def aside_nav?
      false
    end
    helper_method :aside_nav?
end
