class HotwireCombobox::Listbox::Item
  class << self
    def collection_for(view, options, render_in:, include_blank:, **custom_methods)
      new(view, options, render_in: render_in, include_blank: include_blank, **custom_methods).collection
    end
  end

  def initialize(view, options, render_in:, include_blank:, **custom_methods)
    @view, @options, @render_in, @include_blank, @custom_methods =
      view, options, render_in, include_blank, custom_methods
  end

  def collection
    items = groups_or_options
    items.unshift(blank_option) if include_blank.present?
    Collection.new items
  end

  private
    attr_reader :view, :options, :render_in, :include_blank, :custom_methods

    def groups_or_options
      if grouped?
        create_listbox_group options
      else
        create_listbox_options options
      end
    end

    def grouped?
      _key, value = options.to_a.first
      value.is_a? Array
    end

    def create_listbox_group(options)
      options.map do |group_name, group_options|
        HotwireCombobox::Listbox::Group.new group_name, options: create_listbox_options(group_options)
      end
    end

    def create_listbox_options(options)
      if options.first.is_a? HotwireCombobox::Listbox::Option
        options
      else
        options.map do |option|
          HotwireCombobox::Listbox::Option.new(**option_attrs(option))
        end
      end
    end

    def option_attrs(option)
      case option
      when Hash
        option.tap do |attrs|
          attrs[:content] = render_content(object: attrs[:display], attrs: attrs) if render_in.present?
        end
      when String
        {}.tap do |attrs|
          attrs[:display] = option
          attrs[:value] = option
          attrs[:content] = render_content(object: attrs[:display], attrs: attrs) if render_in.present?
        end
      when Array
        {}.tap do |attrs|
          attrs[:display] = option.first
          attrs[:value] = option.last
          attrs[:content] = render_content(object: attrs[:display], attrs: attrs) if render_in.present?
        end
      else
        {}.tap do |attrs|
          attrs[:id] = view.hw_call_method_or_proc(option, custom_methods[:id]) if custom_methods[:id]
          attrs[:display] = view.hw_call_method_or_proc(option, custom_methods[:display]) if custom_methods[:display]
          attrs[:value] = view.hw_call_method_or_proc(option, custom_methods[:value] || :id)

          if render_in.present?
            attrs[:content] = render_content(object: option, attrs: attrs)
          elsif custom_methods[:content]
            attrs[:content] = view.hw_call_method_or_proc(option, custom_methods[:content])
          end
        end
      end
    end

    def render_content(render_opts: render_in, object:, attrs:)
      view.render(**render_opts.reverse_merge(object: object, locals: { combobox_display: attrs[:display], combobox_value: attrs[:value] }))
    end

    def blank_option
      display, content = extract_blank_display_and_content
      HotwireCombobox::Listbox::Option.new display: display, content: content, value: "", blank: true
    end

    def extract_blank_display_and_content
      case include_blank
      when Hash
        text = include_blank.delete(:text)
        [ text, render_content(render_opts: include_blank, object: text, attrs: { display: text, value: "" }) ]
      when String
        [ include_blank, include_blank ]
      else
        [ "", "&nbsp;".html_safe ]
      end
    end
end
