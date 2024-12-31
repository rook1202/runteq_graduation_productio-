# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  # パートナーの一覧ページとネスト
  resources :partners do
    member do
      delete :remove_image
      post :create_token  # 特定のパートナーに対する追加
      post :remove_share
    end
    collection do
      post :create_token  # 全てのパートナーに対する追加
    end
    resources :medications do
      member do
        delete :remove_image
      end
    end
    resources :foods do
      member do
        delete :remove_image
      end
    end
    resources :walks, only: %i[edit update]
  end

  # /complete_tutorial 等を独立したルートとして定義（本来partnersやsettingsと関係ないため）
  post 'complete_tutorial', to: 'partners#complete_tutorial', as: 'complete_tutorial'
  post 'reset_tutorial', to: 'settings#reset_tutorial', as: 'reset_tutorial'

  # ユーザー登録関連
  resources :users, only: %i[new create]

  # ログイン・ログアウト関連
  resources :user_sessions, only: %i[new create destroy]
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  # TOPページ（partners#indexに設定）
  root to: 'partners#index'

  # ログインページを明示的に設定
  get 'login', to: 'user_sessions#new'

  # 設定ページ
  resource :settings, only: %i[show update] do
    get :name_change, on: :collection
    get :news, on: :collection
    get :privacy_policy, on: :collection
    get :terms_of_use, on: :collection
  end

  # 開発環境でのメール設定
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :password_resets, only: %i[new create edit update]

  resources :email_changes, only: %i[new create update] do
    get 'confirm', on: :member
  end

  resources :remainders, only: [:update]

  namespace :api do
    resources :device_tokens, only: %i[create destroy]
  end

  resources :contacts, only: %i[new create]

  get 'share/:token', to: 'partner_shares#confirm', as: :confirm_share
  delete 'mutual_unshare/:user_id', to: 'partner_shares#mutual_unshare', as: :mutual_unshare
  delete 'other_partner_unshare/:user_id', to: 'partner_shares#other_partner_unshare', as: :other_partner_unshare
  delete 'my_partner_unshare/:user_id', to: 'partner_shares#my_partner_unshare', as: :my_partner_unshare

  # SNSログイン
  get '/auth/:provider/callback', to: 'sns_logins#create'
end
