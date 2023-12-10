module HotwireCombobox
  class Engine < ::Rails::Engine
    isolate_namespace HotwireCombobox

    initializer "hotwire_combobox.view_helpers" do
      ActiveSupport.on_load :action_controller do
        helper HotwireCombobox::Helper
      end
    end

    initializer "hotwire_combobox.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end
  end
end
