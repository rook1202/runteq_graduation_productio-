# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

# bootstrap.min.css をプリコンパイルしないため
Rails.application.config.assets.precompile += [
  'application.js',
  'share_partner.js',
  'service_worker_registration.js',
  'trigger_get_player_id.js',
  'application.css',
  'custom_styles.css',
  'noimage.png',
  'controllers/application.js',
  'controllers/hello_controller.js',
  'controllers/index.js'
]
