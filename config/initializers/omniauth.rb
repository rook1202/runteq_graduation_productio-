# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.dig(:google_oauth, :client_id),
           Rails.application.credentials.dig(:google_oauth, :client_secret),
           {
             scope: 'email,profile',
             prompt: 'select_account'
           }

  provider :twitter,
           Rails.application.credentials.dig(:twitter, :api_key),
           Rails.application.credentials.dig(:twitter, :api_secret)

  provider :facebook,
           Rails.application.credentials.dig(:facebook, :app_id),
           Rails.application.credentials.dig(:facebook, :app_secret),
           scope: 'email,public_profile'

  OmniAuth.config.allowed_request_methods = %i[get]
end
