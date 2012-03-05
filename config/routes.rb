Battlecon::Application.routes.draw do
  
  root :to => 'landing#index', :as => :login, :via => :get
  root :to => 'landing#process_login', :via => :post
  match '/logout' => 'landing#logout', :as => :logout
  match '/about' => 'landing#about', :as => :about
  
  resources :players
  resources :characters do
    get '/:vs/' => 'characters#versus', :as => :versus, :on => :member
  end
  resources :matches
  resources :strategy_posts
  
  get 'league(/:id)' => 'leagues#index', :as => :dashboard
  post 'league' => 'leagues#create', :as => :new_league
  post 'league/:id' => 'leagues#join', :as => :join_league
  match 'rankings(/:id)' => 'leagues#rankings', :as => :rankings

end
