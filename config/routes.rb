Rails.application.routes.draw do

  authenticated :user do                   
    get '/expenses', to: 'expenses#index', as: 'expense'
    
    # statistics
    get '/stats/category', to: 'stats#category'
    get '/stats/daily', to: 'stats#daily'
    get '/stats/monthly', to: 'stats#monthly'
    get '/stats/net', to: 'stats#net'

    # csv import
    get '/import', to: 'import#new', as: 'import'
    post '/import', to: 'import#csv', as: 'import_csv'
  end 

  root 'home#index'

  get '/dashboard', to: 'home#dashboard', as: 'dashboard'
  get '/signin', to: 'home#signin', as: 'signin'
  get '/signup', to: 'home#signup', as: 'signup'
  get '/welcome', to: 'home#welcome', as: 'welcome'
  # get '/user', to: 'home#check', as: 'check'
  # get '/about', to: 'home#about', as: 'about'
  # get '/contact', to: 'home#contact', as: 'contact'
  # get '/donation', to: 'home#donation', as: 'donation'
  
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}  
  resources :expenses
end

