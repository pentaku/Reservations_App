Rails.application.routes.draw do
  root to: 'static_pages#home'
  get  '/signup',  to: 'users#new'


  #reservationsコントローラ
  resources :reservations, only: [:index, :show, :edit, :update, :destroy, :create] do
    collection do #collectionはIDを含まないrouting
      post :confirm  # 仮予約確認ページ用
    end
  end

  # roomsコントローラ
  get 'rooms/own', to:'rooms#own', as: 'own_room'
  resources :rooms

  # Sessionコントローラ
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # usersコントローラ
  get 'users/account', to: 'users#account'
  get 'users/profile', to: 'users#profile'
  # asオプションをつけるとedit_password_user_pathというパスヘルパーが生成され、
  # どこからでも簡単に参照できるようになります。
  get 'users/:id/edit_password', to: 'users#edit_password', as: 'edit_password_user'
  patch '/update_password', to: 'users#update_password'
  resources :users
end

