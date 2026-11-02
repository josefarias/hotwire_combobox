module HotwireCombobox::Component::Freetext
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    validate :name_when_new_on_multiselect_must_match_original_name
    validate :value_when_new_must_have_a_name_and_a_single_selection
  end

  private
    def name_when_new
      if free_text && @name_when_new.blank?
        original_field_name
      else
        @name_when_new
      end
    end

    def holds_new_value?
      value_when_new.present?
    end

    def name_when_new_on_multiselect_must_match_original_name
      return unless multiselect? && name_when_new.present?

      unless name_when_new.to_s == original_field_name
        errors.add :name_when_new, :must_match_original_name,
          message: "must match the regular name ('#{original_field_name}', in this case) on multiselect comboboxes."
      end
    end

    def value_when_new_must_have_a_name_and_a_single_selection
      return unless holds_new_value?

      if name_when_new.blank?
        errors.add :value_when_new, :needs_name_when_new, message: "needs name_when_new or free_text."
      elsif multiselect?
        errors.add :value_when_new, :single_selection_only, message: "isn't supported on multiselect comboboxes."
      end
    end
end
