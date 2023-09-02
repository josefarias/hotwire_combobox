require "test_helper"
require "capybara/rails"
require "selenium/webdriver"
require "application_system_test_case"

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new args: [ :headless ]
  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end

Capybara.default_max_wait_time = 10
