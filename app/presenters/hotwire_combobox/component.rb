require "securerandom"

class HotwireCombobox::Component
  include Announced, Associations, Async, Customizable, Freetext, Multiselect, Paginated

  # Markup modules depend on Customizable
  include Markup::Dialog, Markup::Fieldset, Markup::Form, Markup::Handle,
    Markup::HiddenField, Markup::Input, Markup::Label, Markup::Listbox, Markup::Wrapper

  attr_reader :options, :label

  def initialize(
    view, name,
    association_name: nil,
    async_src: nil,
    autocomplete: :both,
    data: {},
    dialog_label: nil,
    form: nil,
    free_text: false,
    id: nil,
    input: {},
    label: nil,
    mobile_at: "640px",
    multiselect_chip_src: nil,
    name_when_new: nil,
    open: false,
    options: [],
    preload: false,
    request: nil,
    value: nil, **rest)
    @view, @autocomplete, @id, @name, @value, @form, @async_src, @label, @free_text, @request,
    @preload, @name_when_new, @open, @data, @mobile_at, @multiselect_chip_src, @options, @dialog_label =
      view, autocomplete, id, name.to_s, value, form, async_src, label, free_text, request,
      preload, name_when_new, open, data, mobile_at, multiselect_chip_src, options, dialog_label

    @combobox_attrs = input.reverse_merge(rest).deep_symbolize_keys
    @association_name = association_name || infer_association_name

    validate!
  end

  def render_in(view_context, &block)
    block.call(self) if block_given?
    view_context.render partial: "hotwire_combobox/component", locals: { component: self }
  end

  private
    attr_reader :view, :autocomplete, :id, :name, :value, :form, :free_text, :open, :request,
      :data, :combobox_attrs, :mobile_at, :association_name, :multiselect_chip_src, :preload

    def canonical_id
      @canonical_id ||= id || form&.field_id(name) || SecureRandom.uuid
    end
end
