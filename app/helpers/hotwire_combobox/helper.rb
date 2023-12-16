module HotwireCombobox
  module Helper
    class << self
      delegate :bypass_convenience_methods?, to: :HotwireCombobox
    end

    def hw_combobox_options(options)
      options.map { |option| hw_combobox_option(**option) }
    end
    alias_method :combobox_options, :hw_combobox_options unless bypass_convenience_methods?

    def hw_combobox_option(...)
      HotwireCombobox::Option.new(...)
    end

    def hw_combobox_tag(...)
      render "hotwire_combobox/combobox", component: HotwireCombobox::Component.new(...)
    end
    alias_method :combobox_tag, :hw_combobox_tag unless bypass_convenience_methods?
  end
end
