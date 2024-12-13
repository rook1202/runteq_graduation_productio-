# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin 'share_partner', to: 'share_partner.js'
pin 'service_worker_registration', to: 'service_worker_registration.js'
pin 'firebase_token_handler', to: 'firebase_token_handler.js'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading',
    to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers',
             under: 'controllers'
pin 'bootstrap', to: 'https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js'
pin '@rails/ujs', to: 'https://ga.jspm.io/npm:@rails/ujs@7.0.0/lib/assets/compiled/rails-ujs.js'
pin 'jquery', to: 'https://code.jquery.com/jquery-3.6.0.min.js'
