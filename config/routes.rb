Rails.application.routes.draw do



  authenticated :user do                   
    get '/', to: 'expenses#index', as: 'dashboard'
  end 

  root 'home#index'
  get '/expenses/daily', to: 'expenses#daily'
  get '/expenses/net', to: 'expenses#net'
  
  devise_for :users
  resources :expenses
end

