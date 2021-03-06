Rails.application.routes.draw do

  authenticated :user do                   
  
    # authenticated api
    get '/expenses', to: 'expenses#index', as: 'expense'

    # html partials
    get '/dashboard', to: 'home#dashboard', as: 'dashboard'
    get '/table', to: 'home#table', as: 'table'
    get '/graph', to: 'home#graph', as: 'graph'
    get '/date', to: 'home#date', as: 'date'
    get '/settings', to: redirect('/users/edit')
    # get '/about', to: 'home#about', as: 'about'
    # get '/contact', to: 'home#contact', as: 'contact'
    # get '/donation', to: 'home#donation', as: 'donation'
    
    # csv import
    get '/import', to: 'import#new', as: 'import'
    post '/import', to: 'import#csv', as: 'import_csv'

    # statistics
    scope '/stats' do
      get '/most', to: 'stats#most', as: 'most'
    end

    # graph
    scope '/graph' do
      get '/bar', to: 'graph#bar', as: 'bar'
      get '/pie', to: 'graph#pie', as: 'pie'
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

  
  devise_for :users, :controllers => {sessions: 'sessions', registrations: 'registrations'}
  resources :expenses
end

