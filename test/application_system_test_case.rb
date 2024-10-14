class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ComboboxActionsHelper
  include ComboboxAssertionsHelper, ViewportAssertionsHelper

  driven_by :selenium, using: :headless_chrome

  def states(...)
    # https://github.com/freerange/mocha/issues/620
    access_fixture("states", ...)
  end
end
