# frozen_string_literal: true

Rails.application.routes.draw do
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
  end

  # 開発環境でのメール設定
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  resources :password_resets, only: %i[new create edit update]

  resources :email_changes, only: %i[new create update] do
    get 'confirm', on: :member
  end

  get 'share/:token', to: 'partner_shares#confirm', as: :confirm_share
  delete 'mutual_unshare/:user_id', to: 'partner_shares#mutual_unshare', as: :mutual_unshare
  delete 'other_partner_unshare/:user_id', to: 'partner_shares#other_partner_unshare', as: :other_partner_unshare
  delete 'my_partner_unshare/:user_id', to: 'partner_shares#my_partner_unshare', as: :my_partner_unshare

end
