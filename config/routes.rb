Rails.application.routes.draw do
  root 'deal_sheets#new'
  resources 'deal_sheets',  only: :create
  get 'deal_sheets/:token', to: 'deal_sheets#show'
  get 'oauth2callback',     to: 'deal_sheets#redirect'


  get 'login',              to: 'sessions#new'
  # post 'sessions/create'    to: 'sessions'
  get 'logout',             to: 'sessions#destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'pdf',                to: 'deal_sheets#pdf'
end
