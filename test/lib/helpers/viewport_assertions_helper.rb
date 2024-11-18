module ViewportAssertionsHelper
  def assert_in_viewport(element, message = "Expected element to be in the viewport, but it was not visible.")
    assert element_in_viewport?(element), message
  end

  def assert_not_in_viewport(element, message = "Expected element to be outside the viewport, but it was visible.")
    assert_not element_in_viewport?(element), message
  end

  private
    def element_in_viewport?(element)
      page.execute_script(<<-JS, element)
        const el = arguments[0]
        const rect = el.getBoundingClientRect()
        return (
          rect.top >= 0 &&
          rect.left >= 0 &&
          rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
          rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        )
      JS
    end
end
