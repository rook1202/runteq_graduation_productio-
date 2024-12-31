# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           Rails.application.credentials.dig(:google_oauth, :client_id),
           Rails.application.credentials.dig(:google_oauth, :client_secret),
           {
             scope: 'email,profile',
             prompt: 'select_account'
           }

  OmniAuth.config.allowed_request_methods = %i[get]
end
