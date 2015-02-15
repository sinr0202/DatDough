Rails.application.routes.draw do



  authenticated :user do                   
    get '/', to: 'users#show'
  end 

  root 'home#index'

  get 'dashboard', to: 'users#show', as: 'dashboard'
  get 'daily_expense_chart', to: 'charts#daily_expense'
  get 'daily_net_chart', to: 'charts#net'
  get 'statistics', to: 'statistics#show'

  resources :expenses
  devise_for :users
end

