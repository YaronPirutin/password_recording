Rails.application.routes.draw do
  match ':controller(/:action(/:id))(.:format)',:via => [:get]
  root :to => "sessions#login"
  match "signup", :to => "users#new",:via => [:get]
  match "users/:id/save_file", :to => "users#save_file",:via => [:post]
  match "new_record", :to => "users#new_record",:via => [:get]
  match "register", :to => "users#new",:via => [:get]
  match "new", :to => "users#new",:via => [:get]
  match "users/create", :to => "users#create",:via => [:post]
  match "sessions/login_attempt", :to => "sessions#login_attempt",:via => [:post]
  match "login", :to => "sessions#login",:via => [:get]
  match "logout", :to => "sessions#logout",:via => [:get]
  match "home", :to => "sessions#home",:via => [:get]
  match "profile", :to => "sessions#profile",:via => [:get]
  match "setting", :to => "sessions#setting",:via => [:get]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
