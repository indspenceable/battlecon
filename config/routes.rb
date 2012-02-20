Battlecon::Application.routes.draw do
  
  root :to => 'landing#index', :as => :login, :via => :get
  root :to => 'landing#process_login', :via => :post
  match '/logout' => 'landing#logout', :as => :logout
  
  resources :players
  resources :characters do
    get '/:vs/' => 'characters#versus', :as => :versus
  end
  resources :matches
  
  match 'league(/:id)' => 'league#index', :as => :dashboard
  match 'rankings(/:id)' => 'league#rankings', :as => :rankings

end
