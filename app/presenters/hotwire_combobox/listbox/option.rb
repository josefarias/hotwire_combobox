class HotwireCombobox::Listbox::Option
  def initialize(option)
    @option = option
  end

  def render_in(view_context)
    view_context.tag.li content, **options
  end

  private
    attr_reader :option

    def content
      option.try(:content) || option.try(:display)
    end

    def options
      {
        id: id,
        role: :option,
        style: "cursor: pointer;",
        data: data
      }
    end

    def id
      option.try(:id)
    end

    def data
      {
        action: "click->hw-combobox#selectOption",
        filterable_as: filterable_as,
        autocompletable_as: autocompletable_as,
        value: value
      }
    end

    def filterable_as
      option.try(:filterable_as) || option.try(:display)
    end

    def autocompletable_as
      option.try(:autocompletable_as) || option.try(:display)
    end

    def value
      option.try(:value) || option.id
    end
end
