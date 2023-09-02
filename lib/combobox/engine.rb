module Combobox
  class Engine < ::Rails::Engine
    isolate_namespace Combobox

    initializer "combobox.view_helpers" do
      ActiveSupport.on_load :action_controller do
        helper Combobox::ApplicationHelper
      end
    end

    initializer "combobox.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end
  end
end
