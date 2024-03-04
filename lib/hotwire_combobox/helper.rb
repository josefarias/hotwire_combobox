module HotwireCombobox
  module Helper
    class << self
      delegate :bypass_convenience_methods?, to: :HotwireCombobox

      def hw_alias(method_name)
        unless bypass_convenience_methods?
          alias_method method_name.to_s.sub(/^hw_/, ""), method_name
        end
      end
    end

    def hw_combobox_style_tag(*args, **kwargs)
      stylesheet_link_tag HotwireCombobox.stylesheet_path, *args, **kwargs
    end
    hw_alias :hw_combobox_style_tag

    def hw_combobox_tag(name, options_or_src = [], render_in: {}, include_blank: nil, **kwargs)
      options, src = hw_extract_options_and_src(options_or_src, render_in, include_blank)
      component = HotwireCombobox::Component.new self, name, options: options, async_src: src, **kwargs

      render "hotwire_combobox/combobox", component: component
    end
    hw_alias :hw_combobox_tag

    def hw_combobox_options(options, render_in: {}, include_blank: nil, display: :to_combobox_display, **methods)
      if options.first.is_a? HotwireCombobox::Listbox::Option
        options
      else
        render_in_proc = render_in.present? ? hw_render_in_proc(render_in) : nil
        options = hw_parse_combobox_options options, render_in: render_in_proc, **methods.merge(display: display)
        options.unshift(hw_blank_option(include_blank)) if include_blank.present?
        options
      end
    end
    hw_alias :hw_combobox_options

    def hw_paginated_combobox_options(options, for_id:, src: request.path, next_page: nil, render_in: {}, include_blank: {}, **methods)
      include_blank = params[:page] ? nil : include_blank
      options = hw_combobox_options(options, render_in: render_in, include_blank: include_blank, **methods)
      this_page = render("hotwire_combobox/paginated_options", for_id: for_id, options: options)
      next_page = render("hotwire_combobox/next_page", for_id: for_id, src: src, next_page: next_page)

      safe_join [ this_page, next_page ]
    end
    hw_alias :hw_paginated_combobox_options

    alias_method :hw_async_combobox_options, :hw_paginated_combobox_options
    hw_alias :hw_async_combobox_options

    protected # library use only
      def hw_listbox_id(id)
        "#{id}-hw-listbox"
      end

      def hw_pagination_frame_wrapper_id(id)
        "#{id}__hw_combobox_pagination__wrapper"
      end

      def hw_pagination_frame_id(id)
        "#{id}__hw_combobox_pagination"
      end

      def hw_combobox_next_page_uri(uri, next_page)
        if next_page
          hw_uri_with_params uri, page: next_page, q: params[:q], format: :turbo_stream
        end
      end

      def hw_combobox_page_stream_action
        params[:page] ? :append : :update
      end

      def hw_blank_option(include_blank)
        display, content =
          if include_blank.is_a? Hash
            text = include_blank.delete(:text)
            [ text, hw_render_in_proc(include_blank).call(text) ]
          else
            [ include_blank, include_blank ]
          end

        HotwireCombobox::Listbox::Option.new display: display, content: content, value: "", blank: true
      end

    private
      def hw_render_in_proc(render_in)
        ->(object) { render(**render_in.reverse_merge(object: object)) }
      end

      def hw_extract_options_and_src(options_or_src, render_in, include_blank)
        if options_or_src.is_a? String
          [ [], hw_uri_with_params(options_or_src, format: :turbo_stream) ]
        else
          [ hw_combobox_options(options_or_src, render_in: render_in, include_blank: include_blank), nil ]
        end
      end

      def hw_uri_with_params(url_or_path, **params)
        URI.parse(url_or_path).tap do |url_or_path|
          query = URI.decode_www_form(url_or_path.query || "").to_h.merge(params)
          url_or_path.query = URI.encode_www_form query
        end.to_s
      rescue URI::InvalidURIError
        url_or_path
      end

      def hw_parse_combobox_options(options, render_in: nil, **methods)
        options.map do |option|
          HotwireCombobox::Listbox::Option.new **hw_option_attrs_for(option, render_in: render_in, **methods)
        end
      end

      def hw_option_attrs_for(option, render_in: nil, **methods)
        case option
        when Hash
          option
        when String
          {}.tap do |attrs|
            attrs[:display] = option
            attrs[:value] = option
            attrs[:content] = render_in.(option) if render_in
          end
        when Array
          {}.tap do |attrs|
            attrs[:display] = option.first
            attrs[:value] = option.last
            attrs[:content] = render_in.(option.first) if render_in
          end
        else
          {}.tap do |attrs|
            attrs[:value] = hw_call_method_or_proc(option, methods[:value] || :id)

            attrs[:id] = hw_call_method_or_proc(option, methods[:id]) if methods[:id]
            attrs[:display] = hw_call_method_or_proc(option, methods[:display]) if methods[:display]
            attrs[:content] = hw_call_method_or_proc(option, render_in || methods[:content]) if render_in || methods[:content]
          end
        end
      end

      def hw_call_method_or_proc(object, method_or_proc)
        if method_or_proc.is_a? Proc
          method_or_proc.call object
        else
          object.public_send method_or_proc
        end
      end
  end
end
