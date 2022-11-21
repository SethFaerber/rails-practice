Rails.application.routes.draw do
  resources :reviews

  root "movies#index"

  resources :movies

  resources :nineties

end
