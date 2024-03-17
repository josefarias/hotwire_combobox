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

    def hw_combobox_tag(name, options_or_src = [], render_in: {}, include_blank: nil, **kwargs, &block)
      options, src = hw_extract_options_and_src(options_or_src, render_in, include_blank)
      component = HotwireCombobox::Component.new self, name, options: options, async_src: src, **kwargs
      render component, &block
    end
    hw_alias :hw_combobox_tag

    def hw_combobox_options(options, render_in: {}, include_blank: nil, display: :to_combobox_display, **methods)
      if options.first.is_a? HotwireCombobox::Listbox::Option
        options
      else
        opts = hw_parse_combobox_options options, render_in_proc: hw_render_in_proc(render_in), **methods.merge(display: display)
        opts.unshift(hw_blank_option(include_blank)) if include_blank.present?
        opts
      end
    end
    hw_alias :hw_combobox_options

    def hw_paginated_combobox_options(options, for_id: params[:for_id], src: request.path, next_page: nil, render_in: {}, include_blank: {}, **methods)
      include_blank = params[:page] ? nil : include_blank
      options = hw_combobox_options options, render_in: render_in, include_blank: include_blank, **methods
      this_page = render "hotwire_combobox/paginated_options", for_id: for_id, options: options
      next_page = render "hotwire_combobox/next_page", for_id: for_id, src: src, next_page: next_page

      safe_join [ this_page, next_page ]
    end
    hw_alias :hw_paginated_combobox_options

    alias_method :hw_async_combobox_options, :hw_paginated_combobox_options
    hw_alias :hw_async_combobox_options

    def hw_combobox_selection_chip(display:, value: params[:combobox_value], for_id: params[:for_id], data: {})
      data = { hw_combobox_chip: "" }.reverse_merge data
      render "hotwire_combobox/selection_chip", display: display, value: value, for_id: for_id, data: data
    end
    hw_alias :hw_combobox_selection_chip

    def hw_dismissing_combobox_selection_chip(*args, **kwargs)
      hw_combobox_selection_chip(*args, **kwargs, data: { hw_combobox_target: "closer" })
    end
    hw_alias :hw_dismissing_combobox_selection_chip

    def hw_combobox_chip_dismisser_attrs(value)
      {
        tabindex: "0",
        class: "hw-combobox__chip__dismisser",
        data: {
          action: "click->hw-combobox#removeChip:stop keydown->hw-combobox#navigateChip",
          hw_combobox_target: "chipDismisser",
          hw_combobox_value_param: value
        }
      }
    end
    hw_alias :hw_combobox_chip_dismisser_attrs

    # private library use only
      def hw_listbox_id(id)
        "#{id}-hw-listbox"
      end

      def hw_pagination_frame_wrapper_id(id)
        "#{id}__hw_combobox_pagination__wrapper"
      end

      def hw_pagination_frame_id(id)
        "#{id}__hw_combobox_pagination"
      end

      def hw_combobox_next_page_uri(uri, next_page, for_id)
        if next_page
          hw_uri_with_params uri,
            page: next_page,
            q: params[:q],
            for_id: for_id,
            format: :turbo_stream
        end
      end

      def hw_combobox_page_stream_action
        params[:page] ? :append : :update
      end

      def hw_blank_option(include_blank)
        display, content = hw_extract_blank_display_and_content include_blank

        HotwireCombobox::Listbox::Option.new display: display, content: content, value: "", blank: true
      end

      def hw_extract_blank_display_and_content(include_blank)
        if include_blank.is_a? Hash
          text = include_blank.delete(:text)

          [ text, hw_call_render_in_proc(hw_render_in_proc(include_blank), text, display: text, value: "") ]
        else
          [ include_blank, include_blank ]
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

    private
      def hw_render_in_proc(render_in)
        if render_in.present?
          ->(object, locals) { render(**render_in.reverse_merge(object: object, locals: locals)) }
        end
      end

      def hw_extract_options_and_src(options_or_src, render_in, include_blank)
        if options_or_src.is_a? String
          [ [], options_or_src ]
        else
          [ hw_combobox_options(options_or_src, render_in: render_in, include_blank: include_blank), nil ]
        end
      end

      def hw_parse_combobox_options(options, render_in_proc: nil, **methods)
        options.map do |option|
          HotwireCombobox::Listbox::Option.new \
            **hw_option_attrs_for(option, render_in_proc: render_in_proc, **methods)
        end
      end

      def hw_option_attrs_for(option, render_in_proc: nil, **methods)
        case option
        when Hash
          option.tap do |attrs|
            attrs[:content] = hw_call_render_in_proc(render_in_proc, attrs[:display], attrs) if render_in_proc
          end
        when String
          {}.tap do |attrs|
            attrs[:display] = option
            attrs[:value] = option
            attrs[:content] = hw_call_render_in_proc(render_in_proc, attrs[:display], attrs) if render_in_proc
          end
        when Array
          {}.tap do |attrs|
            attrs[:display] = option.first
            attrs[:value] = option.last
            attrs[:content] = hw_call_render_in_proc(render_in_proc, attrs[:display], attrs) if render_in_proc
          end
        else
          {}.tap do |attrs|
            attrs[:id] = hw_call_method_or_proc(option, methods[:id]) if methods[:id]
            attrs[:display] = hw_call_method_or_proc(option, methods[:display]) if methods[:display]
            attrs[:value] = hw_call_method_or_proc(option, methods[:value] || :id)

            if render_in_proc
              attrs[:content] = hw_call_render_in_proc(render_in_proc, option, attrs)
            elsif methods[:content]
              attrs[:content] = hw_call_method_or_proc(option, methods[:content])
            end
          end
        end
      end

      def hw_call_render_in_proc(render_in_proc, object, attrs)
        render_in_proc.(object, combobox_display: attrs[:display], combobox_value: attrs[:value])
      end

      def hw_call_method_or_proc(object, method_or_proc)
        if method_or_proc.is_a? Proc
          method_or_proc.call object
        else
          hw_call_method object, method_or_proc
        end
      end

      def hw_call_method(object, method)
        if object.respond_to? method
          object.public_send method
        else
          hw_raise_no_public_method_error object, method
        end
      end

      def hw_raise_no_public_method_error(object, method)
        if object.respond_to? method, true
          header = "`#{object.class}` responds to `##{method}` but the method is not public."
        else
          header = "`#{object.class}` does not respond to `##{method}`."
        end

        if method.to_s == "to_combobox_display"
          header << "\n\nThis method is used to determine how this option should appear in the combobox options list."
        end

        raise NoMethodError, <<~MSG
          [ACTION NEEDED] – Message from HotwireCombobox:

          #{header}

          Please add this as a public method and return a string.

          Example:
            class #{object.class} < ApplicationRecord
              def #{method}
                name # or `title`, `to_s`, etc.
              end
            end
        MSG
      end
  end
end
