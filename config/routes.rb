Rails.application.routes.draw do
  get 'sessions/new'
  root to: 'static_pages#home'
  get  '/signup',  to: 'users#new'
  resources :users
end
