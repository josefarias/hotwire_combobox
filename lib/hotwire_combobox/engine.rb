module HotwireCombobox
  class Engine < ::Rails::Engine
    isolate_namespace HotwireCombobox

    initializer "hotwire_combobox.view_helpers" do
      ActiveSupport.on_load :action_view do
        require "hotwire_combobox/helper"
        ActionView::Base.include HotwireCombobox::Helper

        unless HotwireCombobox.bypass_convenience_methods?
          module FormBuilderExtensions
            def combobox(*args, **kwargs)
              @template.hw_combobox_tag *args, **kwargs.merge(form: self)
            end
          end

          ActionView::Helpers::FormBuilder.include FormBuilderExtensions
        end
      end
    end

    initializer "hotwire_combobox.importmap", before: "importmap" do |app|
      if Rails.application.respond_to?(:importmap)
        app.config.importmap.paths << Engine.root.join("config/importmap.rb")
      end
    end

    initializer "hotwire_combobox.assets.precompile" do |app|
      if Rails.application.config.respond_to?(:assets)
        app.config.assets.precompile << "hw_combobox_manifest.js"
      end
    end
  end
end
