require "securerandom"

class HotwireCombobox::Component
  include Customizable

  attr_reader :options, :label, :multiple

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
      label:            nil,
      mobile_at:        "640px",
      multiple:         false,
      name_when_new:    nil,
      open:             false,
      options:          [],
      value:            nil,
      **rest
    @view, @autocomplete, @id, @name, @value, @form, @async_src, @label,
    @name_when_new, @open, @data, @mobile_at, @multiple, @options, @dialog_label =
      view, autocomplete, id, name.to_s, value, form, async_src, label,
      name_when_new, open, data, mobile_at, multiple, options, dialog_label

    @combobox_attrs = input.reverse_merge(rest).deep_symbolize_keys
    @association_name = association_name || infer_association_name
  end

  def render_in(view_context, &block)
    block.call(self) if block_given?
    view_context.render partial: "hotwire_combobox/component", locals: { component: self }
  end


  def fieldset_attrs
    apply_customizations_to :fieldset, base: {
      class: "hw-combobox#{" hw-combobox--multiple" if multiple}",
      data: fieldset_data
    }
  end


  def label_attrs
    apply_customizations_to :label, base: {
      class: "hw-combobox__label",
      for: input_id,
      hidden: label.blank?
    }
  end


  def hidden_field_attrs
    apply_customizations_to :hidden_field, base: {
      id: hidden_field_id,
      name: hidden_field_name,
      data: hidden_field_data,
      value: hidden_field_value
    }
  end


  def main_wrapper_attrs
    apply_customizations_to :main_wrapper, base: {
      class: "hw-combobox__main__wrapper",
      data: main_wrapper_data
    }
  end


  def inner_wrapper_attrs
    apply_customizations_to :inner_wrapper, base: {
      class: "hw-combobox__inner__wrapper",
      data: { hw_combobox_target: "innerWrapper" }
    }
  end


  def input_attrs
    nested_attrs = %i[ data aria ]

    base = {
      id: input_id,
      role: :combobox,
      class: "hw-combobox__input",
      type: input_type,
      data: input_data,
      aria: input_aria,
      autocomplete: :off
    }.merge combobox_attrs.except(*nested_attrs)

    apply_customizations_to :input, base: base
  end


  def handle_attrs
    apply_customizations_to :handle, base: {
      class: "hw-combobox__handle",
      data: handle_data
    }
  end


  def listbox_attrs
    apply_customizations_to :listbox, base: {
      id: listbox_id,
      role: :listbox,
      class: "hw-combobox__listbox",
      hidden: "",
      data: listbox_data
    }
  end


  def dialog_wrapper_attrs
    apply_customizations_to :dialog_wrapper, base: {
      class: "hw-combobox__dialog__wrapper"
    }
  end

  def dialog_attrs
    apply_customizations_to :dialog, base: {
      class: "hw-combobox__dialog",
      role: :dialog,
      data: dialog_data
    }
  end

  def dialog_label
    @dialog_label || label
  end

  def dialog_label_attrs
    apply_customizations_to :dialog_label, base: {
      class: "hw-combobox__dialog__label",
      for: dialog_input_id
    }
  end

  def dialog_input_attrs
    apply_customizations_to :dialog_input, base: {
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
    apply_customizations_to :dialog_listbox, base: {
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
      data.merge \
        async_id: canonical_id,
        controller: view.token_list("hw-combobox", data[:controller]),
        hw_combobox_expanded_value: open,
        hw_combobox_name_when_new_value: name_when_new,
        hw_combobox_original_name_value: hidden_field_name,
        hw_combobox_autocomplete_value: autocomplete,
        hw_combobox_small_viewport_max_width_value: mobile_at,
        hw_combobox_async_src_value: async_src,
        hw_combobox_prefilled_display_value: prefilled_display,
        hw_combobox_is_multiple_value: multiple,
        hw_combobox_multiple_selections_value: multiple_selections&.to_json,
        hw_combobox_filterable_attribute_value: "data-filterable-as",
        hw_combobox_autocompletable_attribute_value: "data-autocompletable-as",
        hw_combobox_selected_class: "hw-combobox__option--selected",
        hw_combobox_invalid_class: "hw-combobox__input--invalid",
        hw_combobox_navigated_class: "hw-combobox__option--navigated"
    end

    def prefilled_display
      return if multiple

      if async_src && associated_object
        associated_object.to_combobox_display
      elsif hidden_field_value
        options.find { |option| option.value == hidden_field_value }&.autocompletable_as
      end
    end

    def multiple_selections
      return unless multiple

      Array(value).each_with_object({}) do |loop_value, hash|
        hash[loop_value] = options.find { |option| option.value == loop_value }&.content
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

    def async_src
      view.hw_uri_with_params @async_src, for_id: canonical_id, format: :turbo_stream
    end


    def canonical_id
      @canonical_id ||= id || form&.field_id(name) || SecureRandom.uuid
    end


    def main_wrapper_data
      { hw_combobox_target: "mainWrapper" }
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
      combobox_attrs.fetch(:data, {}).merge \
        action: "
          focus->hw-combobox#open
          input->hw-combobox#filterAndSelect
          keydown->hw-combobox#navigate
          click@window->hw-combobox#closeOnClickOutside
          focusin@window->hw-combobox#closeOnFocusOutside
          turbo:before-stream-render@document->hw-combobox#rerouteListboxStreamToDialog".squish,
        hw_combobox_target: "combobox",
        async_id: canonical_id
    end

    def input_aria
      combobox_attrs.fetch(:aria, {}).merge \
        controls: listbox_id,
        owns: listbox_id,
        haspopup: "listbox",
        autocomplete: autocomplete,
        activedescendant: "",
        multiselectable: multiple
    end


    def handle_data
      {
        action: "click->hw-combobox#clearOrToggleOnHandleClick",
        hw_combobox_target: "handle"
      }
    end


    def listbox_id
      "#{canonical_id}-hw-listbox"
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
      "#{canonical_id}-hw-dialog-combobox"
    end

    def dialog_input_data
      {
        action: "
          input->hw-combobox#filterAndSelect
          keydown->hw-combobox#navigate
          click@window->hw-combobox#closeOnClickOutside".squish,
        hw_combobox_target: "dialogCombobox"
      }
    end

    def dialog_input_aria
      {
        controls: dialog_listbox_id,
        owns: dialog_listbox_id,
        autocomplete: autocomplete,
        activedescendant: ""
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
