Rails.application.routes.draw do

  authenticated :user do                   
    get '/', to: 'users#show'
  end 
  root 'home#index'

  get 'dashboard' => 'users#show', as: 'dashboard'

  resources :expenses
  devise_for :users
end
