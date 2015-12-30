Rails.application.routes.draw do

  authenticated :user do                   
  
    # authenticated api
    get '/expenses', to: 'expenses#index', as: 'expense'

    # html partials
    get '/dashboard', to: 'home#dashboard', as: 'dashboard'
    get '/table', to: 'home#table', as: 'table'
    get '/graph', to: 'home#graph', as: 'graph'
    get '/settings', to: redirect('/users/edit')
    
    # csv import
    get '/import', to: 'import#new', as: 'import'
    post '/import', to: 'import#csv', as: 'import_csv'

    # statistics
    scope '/stats' do
      get '/category', to: 'stats#category'
      get '/daily', to: 'stats#daily'
      get '/monthly', to: 'stats#monthly'
      get '/most', to: 'stats#most'
    end
  end 

  root 'home#frame'

  get '/welcome', to: 'home#welcome', as: 'welcome'
  get '/signin', to: 'home#signin', as: 'signin'
  get '/signup', to: 'home#signup', as: 'signup'

  scope '/api' do
    get '/categories', to: 'api#categories', as: 'categories'
    get '/paymethods', to: 'api#paymethods', as: 'paymethods'
  end

  # get '/about', to: 'home#about', as: 'about'
  # get '/contact', to: 'home#contact', as: 'contact'
  # get '/donation', to: 'home#donation', as: 'donation'
  
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}
  resources :expenses
end

