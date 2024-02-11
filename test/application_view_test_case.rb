class ApplicationViewTestCase < ActionView::TestCase
  include ConfigurationHelper

  # `#assert_attrs` expects attrs to appear in the order they are passed.
  def assert_attrs(tag, tag_name: :input, **attrs)
    attrs = attrs.map do |k, v|
      %Q(#{escape_specials(k)}="#{escape_specials(v)}".*)
    end.join(" ")

    assert_match /<#{tag_name}.* #{attrs}/, tag
  end

  def mock_form(form_object: OpenStruct.new)
    form = OpenStruct.new
    form.define_singleton_method(:field_id) { |name| "#{name}_id" }
    form.define_singleton_method(:field_name) { |name| name }
    form.define_singleton_method(:object) { form_object }
    form_object.define_singleton_method(:public_send) do |method_name, *args|
      if form_object.respond_to?(method_name)
        super(method_name, *args)
      else
        raise NoMethodError, "undefined method `#{method_name}` for #{form_object.inspect}"
      end
    end
    form
  end

  private
    def escape_specials(value)
      special_characters = Regexp.union "[]".chars
      value.to_s.gsub(special_characters) { |char| "\\#{char}" }
    end
end
