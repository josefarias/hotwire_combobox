require "test_helper"
require "capybara/rails"
require "selenium/webdriver"
require "application_system_test_case"

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new args: [ :headless ]
  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end

Capybara.default_max_wait_time = 10

Minitest.after_run do
  puts "\n"
  puts <<~WARNING
    ⚠️ Warning
    Focus tests might pass on Selenium but not when checked manually on Chrome.
    Make sure you grep for `assert_focused_combobox` and test manually before releasing a new version.
  WARNING
end
