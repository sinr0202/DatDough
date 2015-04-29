Rails.application.routes.draw do



  authenticated :user do                   
    get '/', to: 'expenses#index', as: 'dashboard'
    get '/expenses/daily', to: 'expenses#daily'
    get '/expenses/net', to: 'expenses#net'
    get '/import', to: 'import#new', as: 'import'
    post '/import', to: 'import#csv', as: 'import_csv'
  end 

  root 'home#index'

  get '/about', to: 'home#about', as: 'about'
  get '/contact', to: 'home#contact', as: 'contact'
  get '/donation', to: 'home#donation', as: 'donation'
  
  devise_for :users
  resources :expenses
end

