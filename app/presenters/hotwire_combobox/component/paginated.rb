module HotwireCombobox::Component::Paginated
  def paginated?
    async_src.present?
  end

  def pagination_attrs
    { for_id: canonical_id, src: async_src }
  end
end
