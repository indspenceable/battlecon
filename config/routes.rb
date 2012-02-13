Battlecon::Application.routes.draw do
  
  root :to => 'landing#index', :as => :login, :via => :get
  root :to => 'landing#process_login', :via => :post
  match '/logout' => 'landing#logout', :as => :logout
  
  resources :players
  resources :characters do
    get '/:id/:id2' => 'characters#versus'
  end
  resources :games
  
  match 'league(/:id)' => 'league#index', :as => :dashboard
  match 'rankings(/:id)' => 'league#rankings', :as => :rankings

end
