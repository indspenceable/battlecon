Battlecon::Application.routes.draw do
  
  root :to => 'landing#index', :as => :login
  resources :players
  resources :characters do
    get '/:id/:id2' => 'characters#versus'
  end
  resources :games
  
  match 'league(/:id)' => 'league#index', :as => :dashboard
  match 'rankings(/:id)' => 'league#rankings', :as => :rankings

end
