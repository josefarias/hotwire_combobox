require "securerandom"

class HotwireCombobox::Listbox::Group
  attr_reader :options

  def initialize(name, options:)
    @name = name
    @options = options
  end

  def render_in(view)
    view.tag.ul(**group_attrs) do
      view.concat view.tag.li(name, **label_attrs)

      options.map do |option|
        view.concat view.render(option)
      end
    end
  end

  private
    attr_reader :name

    def id
      @id ||= SecureRandom.uuid
    end

    def group_attrs
      { class: "hw-combobox__group", role: :group, aria: { labelledby: id } }
    end

    def label_attrs
      { id: id, class: "hw-combobox__group__label", role: :presentation }
    end
end
