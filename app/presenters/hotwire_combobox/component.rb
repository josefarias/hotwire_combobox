class HotwireCombobox::Component
  include ActionView::Helpers::TagHelper

  def initialize(name, value = nil, id: nil, form: nil, open: false, options: [], data: {}, input: {}, **rest)
    @combobox_attrs = input.reverse_merge(rest).with_indifferent_access # input: {} allows for specifying e.g. data attributes on the input field
    @id, @name, @value, @form, @open, @options, @data = id, name, value, form, open, options, data
  end

  def fieldset_attrs
    {
      class: "hw-combobox",
      data: fieldset_data
    }
  end

  def hidden_field_attrs
    {
      id: hidden_field_id,
      name: hidden_field_name,
      data: hidden_field_data,
      value: hidden_field_value
    }
  end

  def input_attrs
    nested_attrs = %i[ data aria ]

    {
      id: input_id,
      role: :combobox,
      type: input_type,
      data: input_data,
      aria: input_aria
    }.merge combobox_attrs.except(*nested_attrs)
  end

  def listbox_attrs
    {
      id: listbox_id,
      role: :listbox,
      hidden: "",
      data: listbox_data
    }
  end

  def listbox_options
    options.map { |option| HotwireCombobox::Listbox::Option.new option }
  end

  private
    attr_reader :id, :name, :value, :form, :open, :options, :data, :combobox_attrs

    def fieldset_data
      data.reverse_merge \
        "controller": token_list("hw-combobox", data[:controller]),
        "hw-combobox-expanded-value": open,
        "hw-combobox-filterable-attribute-value": "data-filterable-as",
        "hw-combobox-autocompletable-attribute-value": "data-autocompletable-as"
    end


    def hidden_field_id
      id || form&.field_id(name)
    end

    def hidden_field_name
      form&.field_name(name) || name
    end

    def hidden_field_data
      { "hw-combobox-target": "hiddenField" }
    end

    def hidden_field_value
      form&.object&.public_send(name) || value
    end


    def input_id
      "#{hidden_field_id}-hw-combobox"
    end

    def input_type
      combobox_attrs[:type].to_s.presence_in(%w[ text search ]) || "text"
    end

    def input_data
      combobox_attrs.fetch(:data, {}).reverse_merge! \
        "action": "
          focus->hw-combobox#open
          input->hw-combobox#filter
          keydown->hw-combobox#navigate
          click@window->hw-combobox#closeOnClickOutside
          focusin@window->hw-combobox#closeOnFocusOutside".squish,
        "hw-combobox-target": "combobox"
    end

    def input_aria
      combobox_attrs.fetch(:aria, {}).reverse_merge! \
        "controls": listbox_id,
        "owns": listbox_id,
        "haspopup": "listbox",
        "autocomplete": "both"
    end


    def listbox_id
      "#{hidden_field_id}-hw-listbox"
    end

    def listbox_data
      { "hw-combobox-target": "listbox" }
    end
end
