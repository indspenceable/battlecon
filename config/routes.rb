Battlecon::Application.routes.draw do
  
  root :to => 'landing#index', :as => :login
  resources :players
  
  match 'league' => 'league#index', :as => :dashboard

end
