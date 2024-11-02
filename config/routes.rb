Rails.application.routes.draw do

  # パートナーの一覧ページとネスト
  resources :partners do
    member do
      delete :remove_image
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
    resources :walks, only: [:edit, :update]
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
