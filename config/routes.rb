Rails.application.routes.draw do

  authenticated :user do                   
    get '/', to: 'expenses#dashboard', as: 'dashboard'
    get '/expenses', to: 'expenses#index', as: 'expense'
    get '/stats/daily', to: 'stats#daily'
    get '/stats/net', to: 'stats#net'
    get '/stats/category', to: 'stats#category'
    get '/import', to: 'import#new', as: 'import'
    post '/import', to: 'import#csv', as: 'import_csv'
    get '/graphs', to: 'graphs#index', as: 'graph'
  end 

  root 'home#index'

  get '/about', to: 'home#about', as: 'about'
  get '/contact', to: 'home#contact', as: 'contact'
  get '/donation', to: 'home#donation', as: 'donation'
  
  devise_for :users
  resources :expenses
end

