module HotwireCombobox
  class Engine < ::Rails::Engine
    isolate_namespace HotwireCombobox

    initializer "hotwire_combobox.view_helpers" do
      ActiveSupport.on_load :action_view do
        include HotwireCombobox::Helper

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
      app.config.importmap.paths << Engine.root.join("config/importmap.rb")
    end

    initializer "hotwire_combobox.assets.precompile" do |app|
      Dir.glob(File.join(Engine.root, "app/assets/**/*.{js,css}")).each do |path|
        app.config.assets.precompile << path
      end
    end
  end
end
