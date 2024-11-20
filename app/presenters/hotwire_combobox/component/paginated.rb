module HotwireCombobox::Component::Paginated
  def paginated?
    async_src.present?
  end

  def pagination_attrs
    { for_id: canonical_id, src: async_src, loading: preload_next_page? ? :eager : :lazy }
  end

  private
    def preload_next_page?
      view.hw_first_page? && preload?
    end

    def preload?
      preload.present?
    end
end
