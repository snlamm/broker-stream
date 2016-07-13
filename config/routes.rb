Rails.application.routes.draw do
  root 'deal_sheets#new'
  resources 'deal_sheets', only: :create
  get 'oauth2callback', to: 'deal_sheets#redirect'
  get 'login',     to: 'sessions#new'
  post 'sessions/create'

  get 'logout',   to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
