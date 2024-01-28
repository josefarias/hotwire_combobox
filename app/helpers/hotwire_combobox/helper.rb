module HotwireCombobox
  module Helper
    class << self
      delegate :bypass_convenience_methods?, to: :HotwireCombobox

      def hw(method_name)
        unless bypass_convenience_methods?
          alias_method method_name.to_s.sub(/^hw_/, ""), method_name
        end
      end
    end

    hw def hw_combobox_style_tag(*args, **kwargs)
      stylesheet_link_tag HotwireCombobox.stylesheet_path, *args, **kwargs
    end

    hw def hw_combobox_tag(*args, async_src: nil, options: [], **kwargs)
      component = HotwireCombobox::Component.new self, *args,
        options: hw_combobox_options(options),
        async_src: hw_uri_with_params(async_src, format: :turbo_stream),
        **kwargs

      render "hotwire_combobox/combobox", component: component
    end

    hw def hw_combobox_options(options, render_in: {}, display: :to_combobox_display, **methods)
      if options.first.is_a? HotwireCombobox::Listbox::Option
        options
      else
        if render_in.present?
          methods[:content] = ->(object) { render **render_in.merge(object: object) }
        end

        hw_parse_combobox_options options, **methods.merge(display: display)
      end
    end

    hw def hw_paginated_combobox_options(options, for_id:, src:, next_page:, render_in: {}, **methods)
      safe_join [
        render(
          "hotwire_combobox/paginated_options",
          for_id: for_id,
          options: hw_combobox_options(options, render_in: render_in, **methods),
          format: :turbo_stream),
        render(
          "hotwire_combobox/next_page",
          src: src,
          next_page: next_page,
          format: :turbo_stream)
      ]
    end

    hw def hw_listbox_options_id(id)
      "#{id}-hw-listbox__options"
    end

    private
      def hw_uri_with_params(url_or_path, **params)
        URI.parse(url_or_path).tap do |url_or_path|
          query = URI.decode_www_form(url_or_path.query || "").to_h.merge(params)
          url_or_path.query = URI.encode_www_form query
        end.to_s
      rescue URI::InvalidURIError
        url_or_path
      end

      def hw_parse_combobox_options(options, **methods)
        options.map do |option|
          attrs = option.is_a?(Hash) ? option : hw_option_attrs_for_obj(option, **methods)
          HotwireCombobox::Listbox::Option.new **attrs
        end
      end

      def hw_option_attrs_for_obj(option, **methods)
        {}.tap do |attrs|
          attrs[:id] = hw_call_method_or_proc(option, methods[:id]) if methods[:id]
          attrs[:value] = hw_call_method_or_proc(option, methods[:value] || :id)
          attrs[:display] = hw_call_method_or_proc(option, methods[:display]) if methods[:display]
          attrs[:content] = hw_call_method_or_proc(option, methods[:content]) if methods[:content]
        end
      end

      def hw_call_method_or_proc(object, method_or_proc)
        if method_or_proc.is_a? Proc
          method_or_proc.call object
        else
          object.public_send method_or_proc
        end
      end

      def hw_combobox_next_page_uri(uri, next_page)
        if next_page
          hw_uri_with_params uri, page: next_page, q: params[:q], format: :turbo_stream
        end
      end

      def hw_combobox_page_stream_action
        params[:page] ? :append : :update
      end
  end
end
