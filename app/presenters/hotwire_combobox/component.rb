class HotwireCombobox::Component
  class << self
    def options_from(view, options)
      if HotwireCombobox::Option === options.first
        options
      else
        view.hw_combobox_options options, display: :to_combobox_display
      end
    end
  end

  def initialize(
      view, name, value = nil,
      autocomplete: :both,
      id: nil,
      form: nil,
      name_when_new: nil,
      open: false,
      small_width: "640px",
      options: [], data: {}, input: {}, **rest)
    @combobox_attrs = input.reverse_merge(rest).with_indifferent_access # `input: {}` allows for specifying e.g. data attributes on the input field
    @options = self.class.options_from view, options

    @view, @autocomplete, @id, @name, @value, @form,
    @name_when_new, @open, @data, @small_width =
      view, autocomplete, id, name, value, form,
      name_when_new, open, data, small_width
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

  def dialog_attrs
    {
      role: :dialog,
      data: dialog_data
    }
  end

  def dialog_input_attrs
    {
      id: dialog_input_id,
      role: :combobox,
      autofocus: "",
      type: input_type,
      data: dialog_input_data,
      aria: dialog_input_aria
    }
  end

  def dialog_listbox_attrs
    {
      id: dialog_listbox_id,
      role: :listbox,
      data: dialog_listbox_data
    }
  end

  def dialog_focus_trap_attrs
    {
      tabindex: "-1",
      data: dialog_focus_trap_data
    }
  end

  private
    attr_reader :view, :autocomplete, :id, :name, :value, :form,
      :name_when_new, :open, :options, :data, :combobox_attrs, :small_width

    def fieldset_data
      data.reverse_merge \
        controller: view.token_list("hw-combobox", data[:controller]),
        hw_combobox_expanded_value: open,
        hw_combobox_name_when_new_value: name_when_new,
        hw_combobox_original_name_value: hidden_field_name,
        hw_combobox_autocomplete_value: autocomplete,
        hw_combobox_small_viewport_max_width_value: small_width,
        hw_combobox_filterable_attribute_value: "data-filterable-as",
        hw_combobox_autocompletable_attribute_value: "data-autocompletable-as"
    end


    def hidden_field_id
      id || form&.field_id(name)
    end

    def hidden_field_name
      form&.field_name(name) || name
    end

    def hidden_field_data
      { hw_combobox_target: "hiddenField" }
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
        action: "
          focus->hw-combobox#open
          input->hw-combobox#filter
          keydown->hw-combobox#navigate
          click@window->hw-combobox#closeOnClickOutside
          focusin@window->hw-combobox#closeOnFocusOutside".squish,
        hw_combobox_target: "combobox"
    end

    def input_aria
      combobox_attrs.fetch(:aria, {}).reverse_merge! \
        controls: listbox_id,
        owns: listbox_id,
        haspopup: "listbox",
        autocomplete: autocomplete
    end


    def listbox_id
      "#{hidden_field_id}-hw-listbox"
    end

    def listbox_data
      { hw_combobox_target: "listbox" }
    end


    def dialog_data
      {
        action: "keydown->hw-combobox#navigate",
        hw_combobox_target: "dialog"
      }
    end

    def dialog_input_id
      "#{hidden_field_id}-hw-dialog-combobox"
    end

    def dialog_input_data
      {
        action: "
          input->hw-combobox#filter
          keydown->hw-combobox#navigate
          click@window->hw-combobox#closeOnClickOutside".squish,
        hw_combobox_target: "dialogCombobox"
      }
    end

    def dialog_input_aria
      {
        controls: dialog_listbox_id,
        owns: dialog_listbox_id,
        autocomplete: autocomplete
      }
    end

    def dialog_listbox_id
      "#{hidden_field_id}-hw-dialog-listbox"
    end

    def dialog_listbox_data
      { hw_combobox_target: "dialogListbox" }
    end

    def dialog_focus_trap_data
      { hw_combobox_target: "dialogFocusTrap" }
    end
end
