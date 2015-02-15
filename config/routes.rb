Rails.application.routes.draw do
  get 'daily_expense_chart', to: 'charts#daily_expense'
  get 'daily_net_chart', to: 'charts#net'
  get 'statistics', to: 'statistics#show'
  root 'home#index'
  resources :expenses
  devise_for :users
end
