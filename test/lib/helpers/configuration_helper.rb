module ConfigurationHelper
  def swap_config(new_configs)
    old_values = {}

    HotwireCombobox.setup do |config|
      new_configs.each do |key, new_value|
        old_values[key] = config.public_send key
        config.public_send :"#{key}=", new_value
      end
    end

    reload_config_dependents

    yield
  ensure
    HotwireCombobox.setup do |config|
      new_configs.each do |key, _|
        config.public_send :"#{key}=", old_values[key]
      end
    end

    reload_config_dependents
  end

  private
    def reload_config_dependents
      HotwireCombobox.send(:remove_const, :Helper)
      load "hotwire_combobox/helper.rb"
    end
end
