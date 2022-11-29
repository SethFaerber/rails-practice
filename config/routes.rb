Rails.application.routes.draw do
  resources :users

  root "movies#index"

  resources :movies do
    resources :reviews
  end

  resources :nineties

  get "signup" => "users#new"

end
