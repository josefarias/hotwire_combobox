class HotwireCombobox::Component
  attr_reader :async_src, :options, :dialog_label

  def initialize \
      view, name,
      association_name: nil,
      async_src:        nil,
      autocomplete:     :both,
      data:             {},
      dialog_label:     nil,
      form:             nil,
      id:               nil,
      input:            {},
      mobile_at:        "640px",
      name_when_new:    nil,
      open:             false,
      options:          [],
      value:            nil,
      **rest
    @view, @autocomplete, @id, @name, @value, @form, @async_src,
    @name_when_new, @open, @data, @mobile_at, @options, @dialog_label =
      view, autocomplete, id, name.to_s, value, form, async_src,
      name_when_new, open, data, mobile_at, options, dialog_label

    @combobox_attrs = input.reverse_merge(rest).with_indifferent_access
    @association_name = association_name || infer_association_name
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
      class: "hw-combobox__input",
      type: input_type,
      data: input_data,
      aria: input_aria
    }.merge combobox_attrs.except(*nested_attrs)
  end


  def handle_attrs
    {
      class: "hw-combobox__handle",
      data: handle_data
    }
  end


  def listbox_attrs
    {
      id: listbox_id,
      role: :listbox,
      class: "hw-combobox__listbox",
      hidden: "",
      data: listbox_data
    }
  end


  def listbox_options_attrs
    { id: listbox_options_id }
  end


  def dialog_wrapper_attrs
    {
      class: "hw-combobox__dialog__wrapper"
    }
  end

  def dialog_attrs
    {
      class: "hw-combobox__dialog",
      role: :dialog,
      data: dialog_data
    }
  end

  def dialog_label_attrs
    {
      class: "hw-combobox__dialog__label",
      for: dialog_input_id
    }
  end

  def dialog_input_attrs
    {
      id: dialog_input_id,
      role: :combobox,
      class: "hw-combobox__dialog__input",
      autofocus: "",
      type: input_type,
      data: dialog_input_data,
      aria: dialog_input_aria
    }
  end

  def dialog_listbox_attrs
    {
      id: dialog_listbox_id,
      class: "hw-combobox__dialog__listbox",
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


  def paginated?
    async_src.present?
  end

  def pagination_attrs
    { for_id: canonical_id, src: async_src }
  end

  private
    attr_reader :view, :autocomplete, :id, :name, :value, :form,
      :name_when_new, :open, :data, :combobox_attrs, :mobile_at,
      :association_name

    def infer_association_name
      if name.include?("_id")
        name.sub(/_id\z/, "")
      end
    end

    def fieldset_data
      data.reverse_merge \
        async_id: canonical_id,
        controller: view.token_list("hw-combobox", data[:controller]),
        hw_combobox_expanded_value: open,
        hw_combobox_name_when_new_value: name_when_new,
        hw_combobox_original_name_value: hidden_field_name,
        hw_combobox_autocomplete_value: autocomplete,
        hw_combobox_small_viewport_max_width_value: mobile_at,
        hw_combobox_async_src_value: async_src,
        hw_combobox_prefilled_display_value: prefilled_display,
        hw_combobox_filterable_attribute_value: "data-filterable-as",
        hw_combobox_autocompletable_attribute_value: "data-autocompletable-as",
        hw_combobox_selected_class: "hw-combobox__option--selected"
    end

    def prefilled_display
      if async_src && associated_object
        associated_object.to_combobox_display
      elsif hidden_field_value
        options.find { |option| option.value == hidden_field_value }&.autocompletable_as
      end
    end

    def associated_object
      @associated_object ||= if association_exists?
        form.object.public_send association_name
      end
    end

    def association_exists?
      form&.object&.class&.reflect_on_association(association_name).present?
    end


    def canonical_id
      id || form&.field_id(name)
    end


    def hidden_field_id
      "#{canonical_id}-hw-hidden-field"
    end

    def hidden_field_name
      form&.field_name(name) || name
    end

    def hidden_field_data
      { hw_combobox_target: "hiddenField" }
    end

    def hidden_field_value
      return value if value

      if form&.object&.defined_enums&.try :[], name
        form.object.public_send "#{name}_before_type_cast"
      else
        form&.object&.try name
      end
    end


    def input_id
      canonical_id
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
        hw_combobox_target: "combobox",
        async_id: canonical_id
    end

    def input_aria
      combobox_attrs.fetch(:aria, {}).reverse_merge! \
        controls: listbox_id,
        owns: listbox_id,
        haspopup: "listbox",
        autocomplete: autocomplete
    end


    def handle_data
      {
        action: "click->hw-combobox#toggle",
        hw_combobox_target: "handle"
      }
    end


    def listbox_id
      "#{canonical_id}-hw-listbox"
    end

    def listbox_data
      { hw_combobox_target: "listbox" }
    end


    def listbox_options_id
      "#{listbox_id}__options"
    end


    def dialog_data
      {
        action: "keydown->hw-combobox#navigate",
        hw_combobox_target: "dialog"
      }
    end

    def dialog_input_id
      "#{canonical_id}-hw-dialog-combobox"
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
      "#{canonical_id}-hw-dialog-listbox"
    end

    def dialog_listbox_data
      { hw_combobox_target: "dialogListbox" }
    end

    def dialog_focus_trap_data
      { hw_combobox_target: "dialogFocusTrap" }
    end
end
