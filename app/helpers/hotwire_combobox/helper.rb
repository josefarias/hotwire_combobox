module HotwireCombobox
  module Helper
    NonCollectionOptions = Class.new StandardError

    class << self
      delegate :bypass_convenience_methods?, to: :HotwireCombobox
    end

    def hw_combobox_style_tag(*args, **kwargs)
      stylesheet_link_tag HotwireCombobox.stylesheet_path, *args, **kwargs
    end
    alias_method :combobox_style_tag, :hw_combobox_style_tag unless bypass_convenience_methods?

    def hw_combobox_tag(*args, **kwargs, &block)
      render "hotwire_combobox/combobox", component: HotwireCombobox::Component.new(self, *args, **kwargs, &block)
    end
    alias_method :combobox_tag, :hw_combobox_tag unless bypass_convenience_methods?

    def hw_combobox_options(options, **methods)
      unless options.respond_to?(:map)
        raise NonCollectionOptions, "options must be an Array or an ActiveRecord::Relation"
      end

      if ActiveRecord::Relation === options || ActiveRecord::Base === options.first
        options.map do |option|
          attrs = {}.tap do |attrs|
            attrs[:id] = option.public_send(methods[:id]) if methods[:id]
            attrs[:value] = option.public_send(methods[:value] || :id)
            attrs[:display] = option.public_send(methods[:display]) if methods[:display]
          end

          hw_combobox_option(**attrs)
        end
      else
        options.map { |option| hw_combobox_option(**option) }
      end
    end
    alias_method :combobox_options, :hw_combobox_options unless bypass_convenience_methods?

    private
      def hw_combobox_option(*args, **kwargs, &block)
        HotwireCombobox::Option.new(*args, **kwargs, &block)
      end
  end
end
