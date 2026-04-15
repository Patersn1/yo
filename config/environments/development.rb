# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true

    #System displays error if there is an issue sending email
    config.action_mailer.perform_deliveries = true

  config.action_mailer.perform_caching = false

  # config.action_mailer.default_url_options = { host: "cabect-celr.hpc.tcnj.edu" }

  #   #ENV are environment variables used to store sensitive data
  #   config.action_mailer.delivery_method = :smtp
  #   config.action_mailer.smtp_settings = {
  #     user_name:      ENV['SENDMAIL_USERNAME'],
  #     password:       ENV['SENDMAIL_PASSWORD'],
  #     domain:         ENV['MAIL_HOST'],
  #     address:       'smtp.gmail.com',
  #     port:          '587',
  #     authentication: :plain,
  #     enable_starttls_auto: true
  #   }

    #Set up email functionality
    config.action_mailer.delivery_method = :smtp

    # Prefer environment variables and correct boolean values. Never commit real passwords.
    config.action_mailer.smtp_settings = {
      address: ENV.fetch("SMTP_ADDRESS", "smtp.gmail.com"),
      port: ENV.fetch("SMTP_PORT", 587).to_i,
      domain: ENV.fetch("SMTP_DOMAIN", "gmail.com"),
      authentication: (ENV["SMTP_AUTH"] || :plain).to_sym,
      enable_starttls_auto: (ENV.key?("SMTP_ENABLE_STARTTLS_AUTO") ? ENV["SMTP_ENABLE_STARTTLS_AUTO"].to_s.downcase == 'true' : true),
      user_name: ENV["SMTP_USERNAME"],
      password: ENV["SMTP_PASSWORD"]
    }.compact

    # If we explicitly disable mail delivery (e.g., during seeding) respect that.
    if ENV["DISABLE_APP_EMAIL"] == 'true'
      config.action_mailer.perform_deliveries = false
    end
  

    #Set default url option to localhost:3000
  config.action_mailer.default_url_options = { host: "https://cab-cce.hpc.tcnj.edu/"}

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  
  config.hosts.clear
end

