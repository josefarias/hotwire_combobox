require "capybara/selenium/driver"

# Chrome 158 rejects the "*" origin Capybara 3.40 clears on reset. Remove this file (and its
# require in test/system_test_helper.rb) once a Capybara release fixes it:
# https://github.com/teamcapybara/capybara/issues/2865 (fixes in #2867, #2868)
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
