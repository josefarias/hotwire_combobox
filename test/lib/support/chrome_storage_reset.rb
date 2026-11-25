require "capybara/selenium/driver"

module ChromeStorageResetForAppOrigin
  private
    def execute_cdp(cmd, params = {})
      if cmd == "Storage.clearDataForOrigin" && params[:origin] == "*"
        super(cmd, params.merge(origin: Capybara.current_session.server.base_url))
      else
        super
      end
    end
end

Capybara::Selenium::Driver::ChromeDriver.prepend ChromeStorageResetForAppOrigin
