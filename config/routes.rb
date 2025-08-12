Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'static_pages#home'
  get  '/signup',  to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  resources :users
  get 'users/:id/edit_password', to: 'users#edit_password'
  patch '/update_password', to: 'users#update_password'
end

