require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Rails4base
  class Application < Rails::Application

      config.time_zone = 'Eastern Time (US & Canada)'

      # custom include paths
      config.autoload_paths += %W["#{config.root}/app/validators"]

      # don't use coffeescript in generators
      config.generators.javascript_engine :js

      config.generators do |g|
          # don't create per-scaffold assets with generator
          g.javascripts false
          g.stylesheets false
          # use custom generator files if they exist
          g.templates.unshift File::expand_path('../../templates', __FILE__)
      end

      # don't log passwords
      config.filter_parameters << :password

      # bootstrap compatible form errors
      config.action_view.field_error_proc = Proc.new { |html_tag, instance|
          html_tag
      }

  end
end
