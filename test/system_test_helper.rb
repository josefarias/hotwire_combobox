require "test_helper"
require "capybara/rails"
require "selenium/webdriver"
require "lib/support/chrome_storage_reset"
require "application_system_test_case"

Capybara.default_max_wait_time = 10

Minitest.after_run do
  puts "\n" + <<~WARNING
    ✋ Warning
    * "no scrolling behind dialog" test needs to be checked manually on mobile Safari (device, not emulator).
    * Tests using `assert_focused_combobox` need to be checked manually on Chrome
  WARNING
end
