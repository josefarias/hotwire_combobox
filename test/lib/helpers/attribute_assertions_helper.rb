module AttributeAssertionsHelper
  # `#assert_attrs` expects attrs to appear in the order they are passed.
  def assert_attrs(tag, tag_name: :input, **attrs)
    assert_match(/<#{tag_name}.* #{escaped_attrs(attrs)}/, tag)
  end

  def assert_no_attrs(tag, tag_name: :input, **attrs)
    assert_no_match(/<#{tag_name}.* #{escaped_attrs(attrs)}/, tag)
  end

  private
    def escaped_attrs(attrs)
      attrs.map do |k, v|
        %Q(#{escape_specials(k)}="#{escape_specials(v)}".*)
      end.join(" ").gsub("&", "&amp;")
    end

    def escape_specials(value)
      special_characters = Regexp.union "[]?".chars
      value.to_s.gsub(special_characters) { |char| "\\#{char}" }
    end
end
