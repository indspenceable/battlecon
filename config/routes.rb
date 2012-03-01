Battlecon::Application.routes.draw do
  
  root :to => 'landing#index', :as => :login, :via => :get
  root :to => 'landing#process_login', :via => :post
  match '/logout' => 'landing#logout', :as => :logout
  
  resources :players
  resources :characters do
    get '/:vs/' => 'characters#versus', :as => :versus, :on => :member
  end
  resources :matches
  resources :strategy_posts
  
  get 'league(/:id)' => 'league#index', :as => :dashboard
  post 'league/:name' => 'league#join', :as => :join_league
  match 'rankings(/:id)' => 'league#rankings', :as => :rankings

end
