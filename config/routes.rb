Rails.application.routes.draw do
  resources :walls, only: :show, :create
  root to: 'static#homepage'
end

