module HotwireCombobox::Component::Async
  private
    def async_src
      view.hw_uri_with_params @async_src, for_id: canonical_id, format: :turbo_stream
    end
end
