Rails.application.routes.draw do
  get 'daily_balance_chart', to: 'charts#daily_balance'
  get 'statistics', to: 'statistics#show'
  root 'home#index'
  resources :expenses
  devise_for :users
end
