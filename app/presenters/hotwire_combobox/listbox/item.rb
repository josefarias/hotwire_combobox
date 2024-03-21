class HotwireCombobox::Listbox::Item
  class << self
    def collection_for(options, render_in, view:, include_blank:, **custom_methods)
      new(view, options, render_in, include_blank: include_blank, **custom_methods).items
    end
  end

  def initialize(view, options, render_in, include_blank:, **custom_methods)
    @view = view
    @options = options
    @render_in = render_in
    @include_blank = include_blank
    @custom_methods = custom_methods
  end

  def items
    if grouped?
      create_listbox_group options
    else
      items = create_listbox_options options
      items.unshift(blank_option) if include_blank.present?
      items
    end
  end

  private
    attr_reader :view, :options, :render_in, :include_blank, :custom_methods

    def grouped?
      key, value = options.to_a.first
      value.is_a? Array
    end

    def create_listbox_group(options)
      options.map do |group_name, group_options|
        HotwireCombobox::Listbox::Group.new group_name,
          options: create_listbox_options(group_options)
      end
    end

    def create_listbox_options(options)
      options.map do |option|
        HotwireCombobox::Listbox::Option.new **option_attrs(option)
      end
    end

    def option_attrs(option)
      case option
      when Hash
        option.tap do |attrs|
          attrs[:content] = call_render_in_proc(render_in_proc(render_in), attrs[:display], attrs) if render_in.present?
        end
      when String
        {}.tap do |attrs|
          attrs[:display] = option
          attrs[:value] = option
          attrs[:content] = call_render_in_proc(render_in_proc(render_in), attrs[:display], attrs) if render_in.present?
        end
      when Array
        {}.tap do |attrs|
          attrs[:display] = option.first
          attrs[:value] = option.last
          attrs[:content] = call_render_in_proc(render_in_proc(render_in), attrs[:display], attrs) if render_in.present?
        end
      else
        {}.tap do |attrs|
          attrs[:id] = view.hw_call_method_or_proc(option, custom_methods[:id]) if custom_methods[:id]
          attrs[:display] = view.hw_call_method_or_proc(option, custom_methods[:display]) if custom_methods[:display]
          attrs[:value] = view.hw_call_method_or_proc(option, custom_methods[:value] || :id)

          if render_in.present?
            attrs[:content] = call_render_in_proc(render_in_proc(render_in), option, attrs)
          elsif custom_methods[:content]
            attrs[:content] = view.hw_call_method_or_proc(option, custom_methods[:content])
          end
        end
      end
    end

    def call_render_in_proc(proc, object, attrs)
      proc.(object, combobox_display: attrs[:display], combobox_value: attrs[:value])
    end

    def blank_option
      display, content = extract_blank_display_and_content
      HotwireCombobox::Listbox::Option.new display: display, content: content, value: "", blank: true
    end

    def extract_blank_display_and_content
      if include_blank.is_a? Hash
        text = include_blank.delete(:text)

        [ text, call_render_in_proc(render_in_proc(include_blank), text, display: text, value: "") ]
      else
        [ include_blank, include_blank ]
      end
    end

    def render_in_proc(render_in_opts)
      if render_in_opts.present?
        ->(object, locals) { view.render(**render_in_opts.reverse_merge(object: object, locals: locals)) }
      end
    end
end
