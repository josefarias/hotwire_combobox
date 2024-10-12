module HotwireCombobox::Component::Freetext
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    validate :name_when_new_on_multiselect_must_match_original_name
  end

  private
    def name_when_new
      if free_text && @name_when_new.blank?
        hidden_field_name
      else
        @name_when_new
      end
    end

    def name_when_new_on_multiselect_must_match_original_name
      return unless multiselect? && name_when_new.present?

      unless name_when_new.to_s == hidden_field_name
        errors.add :name_when_new, :must_match_original_name,
          message: "must match the regular name ('#{hidden_field_name}', in this case) on multiselect comboboxes."
      end
    end
end
