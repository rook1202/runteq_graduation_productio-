Rails.application.routes.draw do
  # パートナーの一覧ページ
  resources :partners
  
  # ユーザー登録関連
  resources :users, only: [:new, :create]
  
  # ログイン・ログアウト関連
  resources :user_sessions, only: [:new, :create, :destroy]
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  # TOPページ（ログイン画面兼用）
  root to: 'user_sessions#new'

end
