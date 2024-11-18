require "platform_agent"

class HotwireCombobox::Platform < PlatformAgent
  def ios?
    mobile_webkit? && !android?
  end

  def android?
    match?(/Android/)
  end

  def mobile_webkit?
    match?(/AppleWebKit/) && match?(/Mobile/)
  end
end
