Rails.application.routes.draw do

  root 'home#index'
  resources :expenses
  devise_for :users
end
