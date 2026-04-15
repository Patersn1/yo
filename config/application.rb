# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Servd
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # Upgrading from 6.0 -> 8.0: load latest defaults then audit differences.
    config.load_defaults 8.0

    # If you are incrementally adopting new default behaviors, you can set
    # config.load_defaults 6.0 first, then manually flip individual new version
    # framework defaults; after review, move to 8.0. (See config/initializers/new_framework_defaults_*.rb)

    # Time zone / i18n adjustments can be set here if needed
    # config.time_zone = 'UTC'
    # config.i18n.available_locales = %i[en]

    # Use Zeitwerk autoloader (default in Rails 6+, mandatory by Rails 8)
    # config.autoload_lib(ignore: %w[assets tasks]) # Example customization

    # Disable legacy assets if moving to Propshaft (uncomment if you adopt propshaft)
    # config.assets.enabled = false

    # Active Job adapter (e.g., :async, :sidekiq). Choose later if background jobs needed.
    # config.active_job.queue_adapter = :async

    # Filter sensitive parameters from logs (ensure credentials removed)
    config.filter_parameters += %i[password password_confirmation token api_key]
  end
end
