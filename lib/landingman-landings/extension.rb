# Require core library
require 'middleman-core'

module Landingman
  class LandingsExtension < ::Middleman::Extension
    TEMPLATES_DIR = File.expand_path(File.join('..', '..', 'templates'), __FILE__)
    option :landings_txt_path, 'landings.txt', 'Path to generate the landings.txt file'
    expose_to_template :landing_pages

    def initialize(app, options_hash={}, &block)
      super
    end

    def after_configuration
      self.register_extension_templates
    end

    def manipulate_resource_list(resources)
      resources << landing_txt_resource
    end

    def landing_pages
      app.sitemap.resources.select do |resource|
        landing_page?(resource)
      end
    end

    protected
      def landing_txt_resource
        source_file = template('landings.txt.erb')
        Middleman::Sitemap::Resource.new(app.sitemap, options.landings_txt_path, source_file).tap do |resource|
          resource.add_metadata(options: { layout: false }, locals: {})
        end
      end

      def template(path)
        full_path = File.join(TEMPLATES_DIR, path)
        raise "Template #{full_path} not found" if !File.exist?(full_path)
        full_path
      end

      def landing_page?(resource)
        is_page?(resource) && resource.data.landing
      end

      def is_page?(resource)
        resource.path.end_with?(page_ext)
      end

      def page_ext
        File.extname(app.config[:index_file])
      end

      def register_extension_templates
        # We call reload_path to register the templates directory with Middleman.
        # The path given to app.files must be relative to the Middleman site's root.
        templates_dir_relative_from_root = Pathname(TEMPLATES_DIR).relative_path_from(Pathname(app.root)).to_s
        # type: source or file
        if !templates_dir_relative_from_root.nil? && Dir.exists?(templates_dir_relative_from_root) then
          app.files.watch(:source, { path: templates_dir_relative_from_root })
        end
      end
  end
end