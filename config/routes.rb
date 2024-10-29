Rails.application.routes.draw do

  # パートナーの一覧ページとネスト
  resources :partners do    
    resources :foods do
      get 'add_remainder_field', on: :collection  # フィールド追加用のルート
    end
    resources :walks do
      get 'add_remainder_field', on: :collection
    end
    resources :medications do
      get 'add_remainder_field', on: :collection
    end
  end
  
  # ユーザー登録関連
  resources :users, only: [:new, :create]
  
  # ログイン・ログアウト関連
  resources :user_sessions, only: [:new, :create, :destroy]
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'
  
  # TOPページ（ログイン画面兼用）
  root to: 'user_sessions#new'

end
