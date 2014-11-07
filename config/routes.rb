Rails.application.routes.draw do

  get 'login' => 'login#index'
  post 'login' => 'login#do'
  get 'logout' => 'login#logout'

  get 'home', to: 'users#home', :as => :home
  resources :users

end
